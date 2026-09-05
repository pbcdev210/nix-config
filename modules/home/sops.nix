{
  settings,
  dirs,
  inputs,
  ...
}:
{
  sops = {
    defaultSopsFile = "${dirs.data}/main.enc.yaml";
    age.keyFile = settings.age.privateKeyPath;
  };

  imports = with inputs; [
    sops-nix.homeManagerModules.sops
  ];

}
