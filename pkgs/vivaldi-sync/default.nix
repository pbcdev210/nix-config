{ settings, pkgs, ... }:

pkgs.writeShellApplication {
  name = "vivaldi-sync";

  runtimeInputs = with pkgs; [
    git
    nushell
    age
  ];

  text = ''
    NIX_CONFIG_DIR="${settings.dirs.nixConfigBot}"
    DATA_DIR="data"
    export NIX_CONFIG_DIR
    export DATA_DIR

    AGE_PUBLIC_KEY="${settings.age.publicKey}"
    AGE_PRIVATE_KEY_PATH="${settings.age.privateKeyPath}"
    export AGE_PUBLIC_KEY
    export AGE_PRIVATE_KEY_PATH

    nu ${./vivaldi-sync.nu} "$@"
  '';
}
