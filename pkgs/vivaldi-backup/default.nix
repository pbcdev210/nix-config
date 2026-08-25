{ settings, pkgs, ... }:

pkgs.writeShellApplication {
  name = "vivaldi-backup";

  runtimeInputs = with pkgs; [
    git
    nushell
  ];

  text = ''
    VIVALDI_VERSION=$(${pkgs.vivaldi}/bin/vivaldi --version)
    REPO_BACKUP="${settings.dirs.nixConfigBot}"
    export VIVALDI_VERSION
    export REPO_BACKUP
    nu ${./vivaldi_actions_manager.nu} --backup
  '';
}







