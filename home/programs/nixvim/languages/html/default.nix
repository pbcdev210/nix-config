{
  programs.nixvim.plugins.lsp.servers.html = {
    enable = true;
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "html"
  ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    html = [ "prettier" ];
  };
}
