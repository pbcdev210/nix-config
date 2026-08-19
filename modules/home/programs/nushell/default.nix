{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;

    plugins = with pkgs.nushellPlugins; [
      query
      formats
      gstat

      highlight
    ];
  };

  stylix.targets.nushell.enable = true;

  programs.zoxide.enableNushellIntegration = true;
  programs.fzf.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  # programs.eza.enableNushellIntegration = true;
  programs.direnv.enableNushellIntegration = true;
  programs.atuin.enableNushellIntegration = true;
  programs.lazygit.enableNushellIntegration = true;
  programs.nix-index.enableNushellIntegration = true;
  programs.nix-your-shell.enableNushellIntegration = true;
}
