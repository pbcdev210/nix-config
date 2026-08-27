{
  programs.nixvim.plugins.lsp.servers.rust_analyzer = {
    enable = true;
    installCargo = true;
    installRustc = true;
    extraOptions = {
      settings = {
        "rust-analyzer" = {
          "checkOnSave.command" = "clippy";
        };
      };
    };
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [ "rust" ];
  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = { rs = [ "rustfmt" ]; };
}
