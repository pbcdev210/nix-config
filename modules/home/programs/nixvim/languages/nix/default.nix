{
  programs.nixvim.plugins.lsp.servers.nixd = {
    enable = true;
    settings = {
      formatting.command = [ "nixpkgs-fmt" ];
      options = {
        nixpkgs.expr = "import <nixpkgs> { }";
      };
    };
  };

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = { nix = [ "alejandra" ]; };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [ "nix" ];
}
