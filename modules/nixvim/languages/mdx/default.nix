{
  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "mdx"
    "markdown"
    "markdown_inline"
  ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    mdx = [ "prettier" ];
  };
}
