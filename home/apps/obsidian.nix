{ pkgs, ... }:
{
  programs.obsidian = {
    enable = true;
    cli.enable = true;

    defaultSettings = {
      communityPlugins = with pkgs.obsidianPlugins; [
        dataview
        obsidian-git
        obsidian-vimrc-support
      ];

      hotkeys = { };
    };

    vaults.main = {
      enable = true;
      target = "/workspaces/vaults/main";
    };
  };

  stylix.targets.obsidian.enable = true;
}
