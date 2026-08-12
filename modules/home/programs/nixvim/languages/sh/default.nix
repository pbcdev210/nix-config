{
  programs.nixvim.plugins.lsp.servers.bashls = {
    enable = true;
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "bash"
  ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    sh = [ "shfmt" ];
    bash = [ "bash" ];
    zsh = [ "shfmt" ];
  };
}
