{
  plugins.lsp.servers.nixd = {
    enable = true;
    settings = {
      formatting.command = [ "nixpkgs-fmt" ];
      options = {
        nixpkgs.expr = "import <nixpkgs> { }";
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft = { nix = [ "alejandra" ]; };

  plugins.treesitter.settings.ensure_installed = [ "nix" ];
}
