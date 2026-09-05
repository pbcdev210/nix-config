{
  inputs,
  base,
  ...
}:
{
  sops = {
    defaultSopsFile = "${base.data}/main.enc.yaml";
    age.keyFile = base.age.privateKeyPath;

    secrets."hashedPassword" = { };
  };

  imports = with inputs; [
    sops-nix.nixosModules.sops
  ];
}
