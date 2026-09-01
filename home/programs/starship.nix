{ settings, pkgs, ... }:
{
  programs.starship = {
    enable = true;

    enableTransience = true;
    settings = {
      add_newline = true;
      format = "$directory$git_branch$git_status$dotnet$line_break$character";

      character = {
        success_symbol = "${settings.glyphs.nix.logo} ${settings.glyphs.prompt}";
        error_symbol = "[${settings.glyphs.level.error}](bold #ff5555)  ${settings.glyphs.prompt}";
      };
    };
  };

  home.packages = [ pkgs.starship ];
  stylix.targets.starship.enable = true;
}
