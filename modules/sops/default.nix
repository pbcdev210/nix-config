{ settings, dirs, ... }:
{
  sops = {
    defaultSopsFile = "${dirs.nixConfig}/secrets/main.yaml";
    age.keyFile = settings.age.privateKeyPath;

    secrets."hashedPassword" = { };
  };
}
