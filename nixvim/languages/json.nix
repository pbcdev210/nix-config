{
  programs.nixvim.plugins.lsp.servers.jsonls = {
    enable = true;

    settings = {
      json = {
        schemas = {
          __raw = "require('schemastore').json.schemas()";
        };
        validate.enable = true;
      };
    };
  };

  programs.nixvim.plugins.schemastore.json.enable = true;

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [ "json" ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = { json = [ "prettier" ]; };
}
