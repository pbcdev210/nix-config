{ settings, pkgs, ... }:
{
  plugins.lsp.servers.nixd = {
    enable = true;
    settings.nixd = {
      formatting.command = [ "alejandra" ];
      options = {
        nixpkgs.expr = "import <nixpkgs> { }";
        nixos.expr = ''(builtins.getFlake "path:${settings.dirs.nixConfig}").nixosConfigurations.default.options'';
        home_manager.expr = ''(builtins.getFlake "path:${settings.dirs.nixConfig}").homeConfigurations.default.options'';
        nixvim.expr = ''(builtins.getFlake "path:${settings.dirs.nixConfig}").legacyPackages.${pkgs.stdenv.system}.nixvimEval.options'';
      };
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft = { nix = [ "alejandra" ]; };

  plugins.treesitter.settings.ensure_installed = [ "nix" ];
}
