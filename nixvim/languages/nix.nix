{ settings, pkgs, ... }:
{
  plugins.lsp.servers.nixd = {
    enable = true;
    settings.nixd = {
      formatting.command = [ "nixpkgs-fmt" ];
      options = {
        nixpkgs.expr = "import <nixpkgs> { }";
        nixos.expr = ''(builtins.getFlake "${settings.dirs.nixConfig}").nixosConfigurations.default.options'';
        home_manager.expr = ''(builtins.getFlake "${settings.dirs.nixConfig}".homeConfigurations.default.options'';
        nixvim.expr = ''(builtins.getFlake "${settings.dirs.nixConfig}".legacyPackages.${pkgs.stdenv.system}.nixvimEval.options'';
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft = { nix = [ "alejandra" ]; };

  plugins.treesitter.settings.ensure_installed = [ "nix" ];
}
