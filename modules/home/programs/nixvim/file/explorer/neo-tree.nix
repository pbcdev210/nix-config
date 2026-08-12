{ settings, ... }:
{
  programs.nixvim.plugins.neo-tree = {
    enable = true;

    settings = {
      close_if_last_window = true;
      async_directory_scan = "always";

      filesystem = {
        filtered_items = {
          visible = true;
          hide_dotfiles = false;
          hide_gitignored = false;
        };

        follow_current_file = {
          enabled = true;
          leave_dirs_open = false;
        };

        window.mappings = { "<esc>" = "close_window"; };
      };

      window = {
        position = "float";
        popupBorderStyle = "rounded";

        popup = {

          position = {
            row = "50%";
            col = "50%";
          };

          size = {
            width = "90%";
            height = "90%";
          };
        };
      };

      default_component_configs = {
        git_status = {
          symbols = {
            added = settings.glyphs.git.diff.added;
            conflict = settings.glyphs.git.diff.conflict;
            deleted = settings.glyphs.git.diff.removed;
            ignored = settings.glyphs.git.diff.ignored;
            modified = settings.glyphs.git.diff.modified;
            renamed = settings.glyphs.git.diff.renamed;
            untracked = settings.glyphs.git.diff.untracked;
          };
        };
      };

      eventHandlers = {
        file_opened = ''
          function()
            require("neo-tree.sources.manager").close_all()
          end
        '';
      };
    };
  };
  programs.nixvim.plugins.lualine.settings.extensions = [ "neo-tree" ];
}
