{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "audio-ducking";

  runtimeInputs = with pkgs; [
    python3
    pipewire
    wireplumber
  ];

  text = ''
    python3 -u ${./daemon.py} "$@"
  '';
}
