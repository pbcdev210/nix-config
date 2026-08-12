{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<A-q>";
      action = "<CMD>Neotree toggle<CR>";
      options = {
        silent = true;
        desc = "Toggle Neo-tree sidebar";
      };
    }

    {
      mode = "n";
      key = "q";
      action = "<cmd>Neotree toggle<CR>";
      options.silent = true;
    }
  ];
}
