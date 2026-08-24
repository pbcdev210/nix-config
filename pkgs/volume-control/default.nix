{ pkgs, dirs, ... }:

pkgs.writeShellApplication {
  name = "volume-control";

  runtimeInputs = with pkgs; [
    wireplumber
    libnotify
    bc
    bash
  ];

  text = ''
    export iDIR="${dirs.assets}/icons"
    bash ${./volume-control.sh} "$@"
  '';
}
