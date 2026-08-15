{ pkgs, ... }:
{
  stylix.fonts = {
    serif = {
      package = pkgs.nerd-fonts.noto;
      name = "NotoSerif Nerd Font";
    };

    sansSerif = {
      package = pkgs.nerd-fonts.ubuntu-sans;
      name = "UbuntuSans Nerd Font";
    };

    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      terminal = 9;
    };
  };
}
