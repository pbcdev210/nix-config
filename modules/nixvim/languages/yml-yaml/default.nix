{
  programs.nixvim.plugins.schemastore.yaml.enable = true;

  programs.nixvim.plugins.lsp.servers.yamlls = {
    enable = true;
    extraOptions = {
      settings = {
        yaml = {
          schemaStore = {
            enable = false;
            url = "";
          };
        };
      };
    };
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [
    "yaml"
  ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    yaml = [ "prettier" ];
    yml = [ "prettier" ];
  };
}
