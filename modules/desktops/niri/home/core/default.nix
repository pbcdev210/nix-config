{
  programs.niri = {
    enable = true;
  };

  imports = [
    ./binds.nix
    ./windown
  ];

  stylix.targets.niri.enable = true;
}
