{
  programs.nixvim.plugins.lsp.servers.jdtls = {
    enable = true;
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [ "java" ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = { java = [ "google-java-format" ]; };
}
