{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<A-f>";
      action = "<CMD>bnext<CR>";
      options = { silent = true; desc = "Next buffer"; };
    }

    {
      mode = "n";
      key = "<A-d>";
      action = "<CMD>bprevious<CR>";
      options = { silent = true; desc = "Previous buffer"; };
    }

    {
      mode = "n";
      key = "<A-s>";
      action = "<CMD>bdelete<CR>";
      options = {
        silent = true;
        desc = "Close current buffer/tab";
      };
    }

    {
      mode = "n";
      key = "<A-a>";
      action = "<CMD>Telescope find_files<CR>";
      options = {
        silent = true;
        desc = "Telescope find files";
      };
    }

    {
      mode = "n";
      key = "<A-w>";
      action = "<CMD>Telescope buffers<CR>";
      options = {
        silent = true;
        desc = "Telescope open buffers";
      };
    }
  ];
}
