{ pkgs, ... }:
{
  programs.obsidian = {
    enable = true;
    cli.enable = true;

    defaultSettings = {
      communityPlugins = with pkgs.obsidianPlugins; [
        dataviwe
        git
      ];
    };
  };

  stylix.targets.obsidian.enable = true;
}
