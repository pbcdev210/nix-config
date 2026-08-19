{
  imports = [
    ./clipboard.nix
    ./history.nix
    # ./motions.nix
  ];

  programs.nixvim.keymaps = [
    {
      mode = [ "i" "c" ];
      key = "<C-BS>";
      action = "<C-w>";
      options = {
        silent = true;
        desc = "Delete inner word with Ctrl+Backspace";
      };
    }

    {
      mode = [ "n" "v" ];
      key = "x";
      action = ''"_x'';
      options.desc = "Delete char into black hole";
    }

    {
      mode = [ "n" "v" ];
      key = "<leader>d";
      action = ''"_d'';
      options = {
        silent = true;
        desc = "Delete without copying to clipboard";
      };
    }

    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.silent = true;
      options.desc = "Clear search highlight";
    }
  ];
}
