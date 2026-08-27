{
  programs.nixvim.plugins.lsp.servers.nushell = {
    enable = true;
  };

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    nu = [ "nu_fmt" ];
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "nu"
  ];
}
