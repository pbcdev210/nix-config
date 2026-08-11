{
  programs.niri = {
    enable = true;
  };

  imports = [
    ./binds.nix
    ./layout.nix
    ./windown.nix
  ];

  stylix.targets.niri.enable = true;
}
