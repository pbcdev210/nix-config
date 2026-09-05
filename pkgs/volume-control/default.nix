{ pkgs, base, ... }:

pkgs.writeShellApplication {
  name = "volume-control";

  runtimeInputs = with pkgs; [
    wireplumber
    libnotify
    bc
    bash
  ];

  text = ''
    export iDIR="${base.assets}/icons"
    bash ${./volume-control.sh} "$@"
  '';
}
