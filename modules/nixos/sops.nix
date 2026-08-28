{ inputs, settings, dirs, ... }:
{
  sops = {
    defaultSopsFile = "${dirs.data}/main.private.yaml";
    age.keyFile = settings.age.privateKeyPath;

    secrets."hashedPassword" = { };
  };

  imports = with inputs; [
    sops-nix.nixosModules.sops
  ];
}
