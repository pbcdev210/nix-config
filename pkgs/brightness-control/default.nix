{ pkgs, dirs, ... }:
pkgs.writeShellApplication {
  name = "brightness-control";

  runtimeInputs = with pkgs; [
    brightnessctl
    libnotify
    gawk
    gnused
    bash
  ];

  text = ''
    export iDIR="${dirs.assets}/icons"
    bash ${./brightness-control.sh} "$@"
  '';
}
