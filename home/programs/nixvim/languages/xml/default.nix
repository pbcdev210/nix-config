{
  programs.nixvim.plugins.lsp.servers.lemminx = {
    enable = true;
    settings = {
      xml = {
        fileAssociations = [
          {
            pattern = "*.csproj";
            systemId = "http://schemas.microsoft.com/developer/msbuild/2003";
          }
        ];
      };
    };
  };

  programs.nixvim.plugins.treesitter.settings.ensure_installed = [ "xml" ];

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = { xml = [ "xmlformatter" ]; };
}
