{
  programs.niri = {
    enable = true;
  };

  imports = [
    ./binds.nix
    ./layout.nix
  ];

  stylix.targets.niri.enable = true;
}
