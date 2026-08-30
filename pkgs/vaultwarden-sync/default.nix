{ pkgs, settings, ... }:
pkgs.writeShellApplication {
  name = "vaultwarden-sync";

  runtimeInputs = with pkgs; [
    sudo
    gnutar
    age
    python3
    git
    su
    sqlite
  ];

  text = ''
    NIX_CONFIG_DIR="${settings.dirs.nixConfigBot}"
    DATA_DIR="data"
    AGE_PUBLIC_KEY="${settings.age.publicKey}"
    AGE_PRIVATE_KEY_PATH="${settings.age.privateKeyPath}"
    USER_MAIN="${settings.identity.username}"
    VAULTWARDEN_USER="vaultwarden"

    export NIX_CONFIG_DIR
    export DATA_DIR
    export AGE_PUBLIC_KEY
    export AGE_PRIVATE_KEY_PATH
    export USER_MAIN
    export VAULTWARDEN_USER
    python3 -u ${./vaultwarden-sync.py} "$@"
  '';
}
