{ settings, ... }:
{
  sops = {
    defaultSopsFile = "${settings.dirs.nixConfig}/secrets/secrets.yaml";
    age.keyFile = "${settings.dirs.home}/.config/sops/age/keys.txt";
  };
}
