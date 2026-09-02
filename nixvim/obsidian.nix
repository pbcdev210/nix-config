{
  plugins.obsidian = {
    enable = true;
    settings = {
      workspaces = [
        {
          name = "main";
          path = "/workspaces/vaults/main";
        }
      ];
      note_id_func.__raw = ''
        function(title)
          if title ~= nil then
            return vim.uri_encode(title)
          else
            return tostring(os.time())
          end
        end
      '';

      legacy_commands = false;
      ui = {
        enable = true;
      };
    };
  };
}
