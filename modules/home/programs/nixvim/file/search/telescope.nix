{
  programs.nixvim.plugins.telescope = {
    enable = true;
    settings = {
      defaults = {
        layout_strategy = "horizontal";
        sorting_strategy = "descending";

        hide_on_startup = true;

        layout_config = {
          prompt_position = "bottom";
          width = 0.9;
          height = 0.9;
          preview_width = 0.6;
        };

        mappings.i = {
          "<Esc>" = {
            __raw = "require('telescope.actions').close";
          };

          "<A-j>" = {
            __raw = "require('telescope.actions').move_selection_next";
          };

          "<A-k>" = {
            __raw = "require('telescope.actions').move_selection_previous";
          };
        };
      };
    };

    keymaps = { "<A-a>" = "find_files"; };
  };
}
