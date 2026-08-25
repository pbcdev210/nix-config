#!/usr/bin/env python3
"""
Smart Audio Ducking for PipeWire / WirePlumber
----------------------------------------------
An advanced background script that automatically ducks (lowers the volume) of a
primary application (Source A) when a transient application (Source B) plays audio.

Features:
- Smooth volume fading.
- True state inspection (prevents false positives when audio streams are merely idle/suspended).
- Hysteresis/Grace period debouncing.
- Manual override via a lockfile.
- Combined inline and JSON-based blacklists.
- Graceful shutdown signal handling to restore volume on exit.
"""

import argparse
import json
import logging
import signal
import subprocess
import sys
import time
from pathlib import Path


class Config:
    """
    Default configuration definitions for the Smart Audio Ducking script.
    These can be overridden at runtime via CLI arguments.
    """
    # Source A: The primary app that will be ducked (case-insensitive substring)
    SOURCE_A = "spotify"

    # Source B: The app that triggers ducking. '*' means ANY active audio stream.
    SOURCE_B = "*"

    # Volume to drop Source A down to (e.g., 0.20 = 20%)
    DUCKING_VOL_PCT = 0.50

    # How often to poll PipeWire state (in seconds)
    CHECK_INTERVAL = 0.2

    # Number of steps for the volume fade-in / fade-out
    FADE_STEPS = 10

    # Total duration of the fade (in seconds)
    FADE_DURATION = 0.25

    # Time (in seconds) to wait after Source B stops before restoring Source A's volume
    GRACE_PERIOD = 0 # IDLE DELAY of wireplumber # TODO Fix

    # File path for manual pause/override. If this file exists, ducking is bypassed.
    LOCK_FILE = "~/.cache/audio_ducking_paused"

    # Default inline blacklist (apps/nodes to ignore even if SOURCE_B = '*')
    # Uses case-insensitive substring matching.
    BLACKLIST = [
        "speech-dispatcher",
        "notification",
        "mic",
        "wireplumber",
        "system-sounds"
    ]


# --- Global state flag for graceful shutdown ---
IS_RUNNING = True

def signal_handler(sig, frame):
    """Handle SIGINT and SIGTERM for graceful shutdown."""
    global IS_RUNNING
    logging.info(f"Received signal {sig}. Initiating graceful shutdown...")
    IS_RUNNING = False


class PipeWireInterface:
    """Handles communication with PipeWire/WirePlumber to get nodes and set volumes."""

    @staticmethod
    def get_audio_streams():
        """
        Query `pw-dump` for all active nodes.
        Returns a list of parsed dictionaries containing stream info.
        """
        try:
            res = subprocess.run(["pw-dump"], capture_output=True, text=True, check=True)
            nodes = json.loads(res.stdout)
        except (subprocess.CalledProcessError, json.JSONDecodeError) as e:
            logging.error(f"Failed to query pw-dump: {e}")
            return []

        streams = []
        for node in nodes:
            if node.get("type") != "PipeWire:Interface:Node":
                continue

            info = node.get("info", {})
            props = info.get("props", {})

            # We only care about application output streams (playback)
            if props.get("media.class") != "Stream/Output/Audio":
                continue

            # Extract identifiers (try application.name first, fallback to node/media name)
            app_name = (
                props.get("application.name") or
                props.get("node.name") or
                props.get("media.name") or
                "Unknown"
            )

            state = info.get("state", "suspended")

            streams.append({
                "id": node.get("id"),
                "name": app_name,
                "state": state
            })

        return streams

    @staticmethod
    def get_volume(node_id):
        """Retrieve the current volume of a specific node using wpctl."""
        try:
            res = subprocess.run(["wpctl", "get-volume", str(node_id)], capture_output=True, text=True)
            if res.returncode == 0:
                # Example output: "Volume: 0.75" or "Volume: 0.75 [MUTED]"
                parts = res.stdout.strip().split()
                if len(parts) >= 2:
                    return float(parts[1])
        except Exception as e:
            logging.debug(f"Failed to get volume for node {node_id}: {e}")
        return None

    @staticmethod
    def set_volume(node_id, volume):
        """Set the volume of a specific node using wpctl."""
        try:
            # Ensure volume stays strictly within 0.0 and 1.0 bounds
            clamped_vol = max(0.0, min(1.0, volume))
            subprocess.run(["wpctl", "set-volume", str(node_id), f"{clamped_vol:.2f}"], check=True)
        except Exception as e:
            logging.debug(f"Failed to set volume for node {node_id}: {e}")


class DuckingManager:
    """Manages the application state, node tracking, and fading logic."""

    def __init__(self, config):
        self.config = config

        # Track original volumes of ducked nodes: { node_id: original_volume_float }
        self.ducked_nodes = {}

        # Hysteresis state
        self.last_b_active_time = 0.0
        self.currently_ducking = False

    def is_blacklisted(self, app_name):
        """Check if an app matches any entry in the blacklist."""
        app_lower = app_name.lower()
        return any(b.lower() in app_lower for b in self.config.BLACKLIST)

    def is_target(self, app_name, target):
        """Check if an app matches the specified target."""
        if target == "*":
            return True
        return target.lower() in app_name.lower()

    def fade_node_volume(self, node_id, start_vol, end_vol):
        """Apply smooth step-based volume transitioning for a specific node."""
        if start_vol == end_vol:
            return

        logging.debug(f"Fading Node {node_id} from {start_vol:.2f} to {end_vol:.2f}")
        steps = self.config.FADE_STEPS
        step_time = self.config.FADE_DURATION / steps

        for i in range(1, steps + 1):
            current = start_vol + (end_vol - start_vol) * (i / steps)
            PipeWireInterface.set_volume(node_id, current)
            time.sleep(step_time)

    def duck_source_a(self, a_nodes):
        """Fade Source A streams down to the ducking volume."""
        target_vol = self.config.DUCKING_VOL_PCT
        for node in a_nodes:
            node_id = node["id"]
            if node_id not in self.ducked_nodes:
                current_vol = PipeWireInterface.get_volume(node_id)
                if current_vol is None:
                    continue

                # Only duck if the original volume is higher than the duck target
                if current_vol > target_vol:
                    self.ducked_nodes[node_id] = current_vol
                    self.fade_node_volume(node_id, current_vol, target_vol)

        self.currently_ducking = True

    def restore_source_a(self, a_nodes=None):
        """Restore Source A streams back to their original volumes."""
        if not self.ducked_nodes:
            self.currently_ducking = False
            return

        logging.info("Restoring Source A volume(s)...")
        # Snapshot dictionary items to avoid RuntimeError during iteration deletion
        for node_id, orig_vol in list(self.ducked_nodes.items()):
            # Get current volume to fade smoothly from current -> original
            current_vol = PipeWireInterface.get_volume(node_id)
            if current_vol is not None:
                self.fade_node_volume(node_id, current_vol, orig_vol)

            # Remove from tracked state once restored
            del self.ducked_nodes[node_id]

        self.currently_ducking = False

    def run(self):
        """Main monitoring loop."""
        logging.info(f"Started Smart Ducking. Primary: '{self.config.SOURCE_A}', Trigger: '{self.config.SOURCE_B}'")
        logging.info(f"Lock file path: {self.config.LOCK_FILE}")

        lock_path = Path(self.config.LOCK_FILE).expanduser()

        while IS_RUNNING:
            try:
                # 1. Manual Override check
                if lock_path.exists():
                    if self.currently_ducking:
                        logging.info("Lock file detected. Temporarily bypassing ducking.")
                        self.restore_source_a()
                    time.sleep(self.config.CHECK_INTERVAL)
                    continue

                # 2. Query nodes
                streams = PipeWireInterface.get_audio_streams()

                a_nodes = []
                b_active = False
                active_b_names = []

                # 3. Classify Streams
                for s in streams:
                    # Ignore blacklisted applications
                    if self.is_blacklisted(s["name"]):
                        continue

                    is_a = self.is_target(s["name"], self.config.SOURCE_A)
                    is_b = self.is_target(s["name"], self.config.SOURCE_B)

                    if is_a:
                        a_nodes.append(s)
                    elif is_b and not is_a:
                        # Inspect TRUE playback state.
                        # 'running' means actively outputting audio frames.
                        # 'idle' / 'suspended' means the node is kept alive but paused.
                        if s["state"] == "running":
                            b_active = True
                            active_b_names.append(s["name"])

                # 4. State Evaluation & Hysteresis Timer
                current_time = time.time()

                if b_active:
                    self.last_b_active_time = current_time
                    if not self.currently_ducking:
                        logging.info(f"Ducking triggered by: {', '.join(set(active_b_names))}")
                    self.duck_source_a(a_nodes)
                else:
                    # If B is not active, check if grace period has expired
                    if self.currently_ducking:
                        time_since_active = current_time - self.last_b_active_time
                        if time_since_active >= self.config.GRACE_PERIOD:
                            self.restore_source_a()

            except Exception as e:
                logging.error(f"Unexpected error in main loop: {e}")

            # Wait for next poll
            time.sleep(self.config.CHECK_INTERVAL)

        # Cleanup when broken out of loop (via signals)
        self.cleanup()

    def cleanup(self):
        """Restore all volumes on script exit."""
        logging.info("Cleaning up and restoring volumes...")
        self.restore_source_a()
        logging.info("Exited.")


def parse_arguments():
    """Parse CLI arguments to dynamically override configuration."""
    parser = argparse.ArgumentParser(
        description="Smart Audio Ducking using PipeWire/WirePlumber.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

    parser.add_argument("--source-a", default=Config.SOURCE_A,
                        help="Primary application to duck (substring match).")
    parser.add_argument("--source-b", default=Config.SOURCE_B,
                        help="Application that triggers ducking, or '*' for any.")
    parser.add_argument("--duck-vol", type=float, default=Config.DUCKING_VOL_PCT,
                        help="Target volume (0.0 to 1.0) for Source A when ducked.")
    parser.add_argument("--check-interval", type=float, default=Config.CHECK_INTERVAL,
                        help="Polling interval in seconds.")
    parser.add_argument("--grace-period", type=float, default=Config.GRACE_PERIOD,
                        help="Delay in seconds before restoring volume.")
    parser.add_argument("--fade-steps", type=int, default=Config.FADE_STEPS,
                        help="Number of steps for volume fading.")
    parser.add_argument("--blacklist-json", type=str,
                        help="Path to an external JSON file containing a list of strings to blacklist.")
    parser.add_argument("--debug", action="store_true",
                        help="Enable verbose debugging output.")

    return parser.parse_args()


def main():
    args = parse_arguments()

    # Configure logging
    log_level = logging.DEBUG if args.debug else logging.INFO
    logging.basicConfig(level=log_level, format="[%(levelname)s] %(message)s")

    # Initialize Configuration
    cfg = Config()
    cfg.SOURCE_A = args.source_a
    cfg.SOURCE_B = args.source_b
    cfg.DUCKING_VOL_PCT = args.duck_vol
    cfg.CHECK_INTERVAL = args.check_interval
    cfg.GRACE_PERIOD = args.grace_period
    cfg.FADE_STEPS = args.fade_steps

    # Load JSON Blacklist if provided
    if args.blacklist_json:
        bl_path = Path(args.blacklist_json).expanduser()
        if bl_path.exists():
            try:
                with open(bl_path, 'r') as f:
                    external_bl = json.load(f)
                    if isinstance(external_bl, list):
                        cfg.BLACKLIST.extend(external_bl)
                        logging.info(f"Loaded {len(external_bl)} blacklist items from {bl_path}")
                    else:
                        logging.warning("JSON blacklist must be a list of strings. Ignoring.")
            except Exception as e:
                logging.error(f"Failed to load JSON blacklist: {e}")
        else:
            logging.warning(f"JSON blacklist file '{bl_path}' not found. Using defaults.")

    logging.debug(f"Effective Blacklist: {cfg.BLACKLIST}")

    # Bind graceful shutdown signals
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    # Initialize and run Manager
    manager = DuckingManager(cfg)
    manager.run()


if __name__ == "__main__":
    main()
