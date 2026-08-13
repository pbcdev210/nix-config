{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<A-e>";
      action = "<CMD>undo<CR>";
      options = {
        silent = true;
        desc = "Undo changes safely";
      };
    }

    {
      mode = "n";
      key = "<A-r>";
      action = "<CMD>redo<CR>";
      options = {
        silent = true;
        desc = "Redo changes safely";
      };
    }
  ];
}
