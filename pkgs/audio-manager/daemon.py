#!/usr/env/bin python3
"""
audio-manager: Advanced Smart Audio Ducking Daemon for Linux.
Leverages playerctl and MPRIS protocol for robust audio management.
"""

import argparse
import json
import logging
import os
import signal
import subprocess
import sys
import threading
import time
from pathlib import Path

# Configure logging to output directly to stdout/stderr without manual timestamps
# (systemd journal automatically prepends timestamps)
logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format="%(levelname)s: %(message)s"
)
logger = logging.getLogger("audio-manager")


class Config:
    """Centralized configuration class for audio-manager."""
    def __init__(self):
        self.primary_player = "spotify"
        self.transient_player = "*"  # Can be '*' or a specific player name like 'vivaldi'
        self.check_interval = 0.5    # Loop check interval in seconds
        self.fade_steps = 10         # Number of steps for smooth volume transition
        self.fade_delay = 0.02       # Delay between fade steps in seconds
        self.pause_lock_path = Path("~/.cache/audio_manager_paused").expanduser()
        self.blacklist = ["vlc", "mpv", "firefox"]  # Default inline blacklist (case-insensitive)
        self.blacklist_json_path = None
        self.debug = False


class AudioManager:
    """Core daemon controller implementing smart audio ducking logic."""

    def __init__(self, config: Config):
        self.config = config
        self.running = True
        self.current_volume = 1.0
        self.target_volume = 1.0
        self.spotify_artist = ""
        self._artist_thread = None
        self._lock = threading.Lock()

        # Register signal handlers for graceful shutdown
        signal.signal(signal.SIGINT, self._handle_exit)
        signal.signal(signal.SIGTERM, self._handle_exit)

    def _handle_exit(self, signum, frame):
        """Signal handler for graceful shutdown and volume restoration."""
        logger.info(f"Received signal {signum}. Shutting down gracefully...")
        self.running = False
        try:
            logger.info("Restoring Spotify volume to 100%...")
            self._set_spotify_volume_immediate(1.0)
        except Exception as e:
            logger.error(f"Failed to restore volume on exit: {e}")
        sys.exit(0)

    def load_blacklist(self) -> set:
        """Loads and combines inline blacklist and external JSON blacklist."""
        blacklisted = {item.lower() for item in self.config.blacklist}

        if self.config.blacklist_json_path:
            json_path = Path(self.config.blacklist_json_path).expanduser()
            if json_path.exists():
                try:
                    with open(json_path, "r", encoding="utf-8") as f:
                        data = json.load(f)
                        if isinstance(data, list):
                            blacklisted.update(item.lower() for item in data)
                            logger.info(f"Loaded {len(data)} blacklisted players from {json_path}")
                except Exception as e:
                    logger.error(f"Failed to load blacklist JSON from {json_path}: {e}")
            else:
                logger.warning(f"Blacklist JSON path specified but not found: {json_path}")

        return blacklisted

    def _run_cmd(self, cmd: list) -> str:
        """Helper to run shell commands and return stripped stdout."""
        try:
            result = subprocess.run(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                check=True
            )
            return result.stdout.strip()
        except subprocess.CalledProcessError as e:
            if self.config.debug:
                logger.debug(f"Command {' '.join(cmd)} failed: {e.stderr.strip()}")
            return ""
        except FileNotFoundError:
            logger.error("Required tool 'playerctl' is not installed or not in PATH.")
            sys.exit(1)

    def get_active_players(self) -> list:
        """Returns a list of currently active/playing MPRIS players."""
        output = self._run_cmd(["playerctl", "-l"])
        if not output:
            return []

        players = []
        blacklisted = self.load_blacklist()

        for player in output.splitlines():
            player_name = player.strip()
            if not player_name:
                continue

            # Check blacklist (case-insensitive)
            if any(b in player_name.lower() for b in blacklisted):
                if self.config.debug:
                    logger.debug(f"Player '{player_name}' is blacklisted. Ignoring.")
                continue

            # Check if the player is currently playing
            status = self._run_cmd(["playerctl", "--player", player_name, "status"])
            if status.lower() == "playing":
                players.append(player_name.lower())

        return players

    def _set_spotify_volume_immediate(self, volume: float):
        """Directly sets Spotify volume via playerctl (0.0 to 1.0)."""
        vol_clamped = max(0.0, min(1.0, volume))
        self._run_cmd(["playerctl", "--player", self.config.primary_player, "volume", str(vol_clamped)])
        self.current_volume = vol_clamped

    def set_spotify_volume_smooth(self, target: float):
        """Smoothly transitions Spotify volume to target value using steps."""
        target = max(0.0, min(1.0, target))
        if abs(self.current_volume - target) < 0.01:
            return

        steps = self.config.fade_steps
        step_diff = (target - self.current_volume) / steps

        for _ in range(steps):
            if not self.running:
                break
            with self._lock:
                self.current_volume += step_diff
                self._set_spotify_volume_immediate(self.current_volume)
            time.sleep(self.config.fade_delay)

        with self._lock:
            self._set_spotify_volume_immediate(target)

    def _monitor_spotify_artist(self):
        """Continuously monitors Spotify artist metadata in real-time using playerctl -F."""
        cmd = ["playerctl", "--player", self.config.primary_player, "metadata", "--format", "{{artist}}", "-F"]
        logger.info("Starting real-time Spotify artist monitoring thread...")

        while self.running:
            try:
                process = subprocess.Popen(
                    cmd,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True
                )

                while self.running and process.poll() is None:
                    line = process.stdout.readline()
                    if line:
                        artist = line.strip()
                        with self._lock:
                            self.spotify_artist = artist
                        if self.config.debug:
                            logger.debug(f"Spotify artist updated: '{artist}'")

                process.terminate()
            except Exception as e:
                logger.error(f"Error in Spotify artist monitoring stream: {e}")
                time.sleep(2)

    def run(self):
        """Main daemon loop."""
        logger.info(f"Starting audio-manager daemon. Primary player: {self.config.primary_player}")
        logger.info(f"Transient source configuration: {self.config.transient_player}")

        # Start background thread for real-time artist monitoring
        self._artist_thread = threading.Thread(target=self._monitor_spotify_artist, daemon=True)
        self._artist_thread.start()

        while self.running:
            try:
                # Check for manual override lock file
                if self.config.pause_lock_path.exists():
                    if self.config.debug:
                        logger.debug(f"Pause lock file detected at {self.config.pause_lock_path}. Ducking bypassed.")
                    time.sleep(self.config.check_interval)
                    continue

                # Check if Spotify is running/available
                active_players = self.get_active_players()
                spotify_active = any(self.config.primary_player in p for p in active_players)

                if not spotify_active:
                    if self.config.debug:
                        logger.debug("Spotify is not active or playing. Waiting...")
                    time.sleep(self.config.check_interval)
                    continue

                # Determine Target Volume based on rules
                with self._lock:
                    current_artist = self.spotify_artist

                # Rule 1: Empty Artist -> Immediately lower Spotify's volume to 0%
                if current_artist == "":
                    self.target_volume = 0.0
                    if self.config.debug:
                        logger.debug("Rule 1 triggered: Artist is empty -> Target Volume: 0%")
                else:
                    # Rule 2: Non-Empty Artist -> Check Source B status
                    transient_active = False
                    if self.config.transient_player == "*":
                        # Any other active player except spotify
                        other_players = [p for p in active_players if self.config.primary_player not in p]
                        transient_active = len(other_players) > 0
                        if transient_active and self.config.debug:
                            logger.debug(f"Active transient players detected: {other_players}")
                    else:
                        transient_active = any(self.config.transient_player.lower() in p for p in active_players)

                    if transient_active:
                        self.target_volume = 0.5  # 50% ducking
                        if self.config.debug:
                            logger.debug("Rule 2 triggered: Source B is active -> Target Volume: 50%")
                    else:
                        self.target_volume = 1.0  # Full volume
                        if self.config.debug:
                            logger.debug("Rule 2 triggered: Source B is stopped -> Target Volume: 100%")

                # Enforce and re-apply target volume per loop cycle (fixing track change resets)
                if abs(self.current_volume - self.target_volume) > 0.01:
                    if self.config.debug:
                        logger.debug(f"Adjusting volume from {self.current_volume:.2f} to target {self.target_volume:.2f}")
                    self.set_spotify_volume_smooth(self.target_volume)
                else:
                    # Even if close, continuously enforce to prevent track change resets
                    self._set_spotify_volume_immediate(self.target_volume)

            except Exception as e:
                logger.error(f"Error in main loop: {e}", exc_info=self.config.debug)

            time.sleep(self.config.check_interval)


def parse_arguments() -> Config:
    """Parses command-line arguments and returns a populated Config instance."""
    config = Config()
    parser = argparse.ArgumentParser(
        description="Advanced Smart Audio Ducking Daemon for Linux using playerctl."
    )
    parser.add_argument(
        "--primary",
        default=config.primary_player,
        help="Primary background player (default: spotify)"
    )
    parser.add_argument(
        "--transient",
        default=config.transient_player,
        help="Transient source B: '*' for any active player or specific player name (default: '*')"
    )
    parser.add_argument(
        "--interval",
        type=float,
        default=config.check_interval,
        help="Main loop check interval in seconds (default: 0.5)"
    )
    parser.add_argument(
        "--blacklist-json",
        default=None,
        help="Path to external JSON file containing a list of blacklisted players"
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable verbose debug logging"
    )

    args = parser.parse_args()

    config.primary_player = args.primary
    config.transient_player = args.transient
    config.check_interval = args.interval
    config.blacklist_json_path = args.blacklist_json
    config.debug = args.debug

    if config.debug:
        logger.setLevel(logging.DEBUG)
        logger.debug("Debug logging enabled.")

    return config


if __name__ == "__main__":
    app_config = parse_arguments()
    manager = AudioManager(app_config)
    manager.run()
