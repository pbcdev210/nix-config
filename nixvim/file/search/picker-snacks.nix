{ settings, ... }:
{
  plugins.snacks.settings.picker = {
    enabled = true;

    prompt = settings.glyphs.prompt;

    layout = {
      layout = {
        width = 0.9;
        height = 0.9;
      };

      preset.__raw = ''
        function()
          return vim.o.columns >= 120 and "default" or "vertical"
        end
      '';
    };

    icons = {
      git = {
        enabled = true;
        commit = settings.glyphs.git.commit;
        staged = settings.glyphs.git.staged;
        added = settings.glyphs.git.diff.added;
        modified = settings.glyphs.git.diff.modified;
        removed = settings.glyphs.git.diff.removed;
        deleted = settings.glyphs.git.diff.removed;
        conflict = settings.glyphs.git.diff.conflict;
        ignored = settings.glyphs.git.diff.ignored;
        untracked = settings.glyphs.git.diff.untracked;
        renamed = settings.glyphs.git.diff.renamed;
      };

      diagnostics = {
        Error = settings.glyphs.level.error;
        Warn = settings.glyphs.level.warn;
        Hint = settings.glyphs.level.hint;
        Info = settings.glyphs.level.info;
      };

    };

    formatters = {
      file = {
        filename_first = true;

        truncate = "center";

        icon_width = 2;
        git_status_hl = true;

        severity = {
          icons = true;
          level = false;
          pos = "left";
        };
      };
    };

    win = {
      input = {
        keys = {
          "<A-a>".__raw = ''{ "cancel", mode = { "i", "n" } }'';
          "<A-w>".__raw = ''{ "cancel", mode = { "i", "n" }, }'';
          "<A-s>".__raw = ''{ "bufdelete", mode = { "i", "n" }, }'';
        };
      };
      list = {
        keys = {
          "<A-a>".__raw = ''{ "cancel", mode = { "i", "n" }, }'';
          "<A-w>".__raw = ''{ "cancel", mode = { "i", "n" }, }'';
          "<A-s>".__raw = ''{ "bufdelete", mode = { "i", "n" }, }'';
          "s".__raw = ''{ "bufdelete", mode = { "n" }, }'';
        };
      };
    };

    sources = {
      files = {
        enabled = true;

        hidden = true;
        ignored = true;
      };

      smart = {
        enabled = true;

        hidden = true;
        ignored = true;
      };
    };
    exclude = settings.ignores;
  };

  keymaps = [
    {
      mode = "n";
      key = "<A-a>";
      action.__raw = ''
        function()
          Snacks.picker({ source = "files" })
        end
      '';
      options.desc = "Find Files";
    }
    {
      mode = "n";
      key = "<A-w>";
      action.__raw = ''
        function()
          Snacks.picker({ source = "buffers" })
        end
      '';
      options.desc = "List Buffers";
    }
  ];
}
