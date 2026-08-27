{
  programs.nixvim.plugins.lsp.servers.cssls = {
    enable = true;
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "css"
    "scss"
  ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    css = [ "prettier" ];
    scss = [ "prettier" ];
    less = [ "prettier" ];
  };
}
