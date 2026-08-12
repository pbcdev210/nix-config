{
  programs.nixvim.plugins.lsp.servers.bazelrc_lsp = {
    enable = true;
    package = null;
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "bazel"
    "starlark"
  ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    bazel = [ "buildifier" ];
    bzl = [ "buildifier" ];
  };
}
