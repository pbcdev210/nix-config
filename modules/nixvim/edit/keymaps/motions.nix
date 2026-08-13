{
  programs.nixvim.keymaps = [
    {
      mode = [ "n" "v" ];
      key = "<leader>q";
      action = "<cmd>keepjumps normal! gg<CR>";
      options.desc = "Top of file";
    }

    {
      mode = [ "n" "v" ];
      key = "<leader>w";
      action = "<cmd>normal! M<CR>";
      options.desc = "Middle of screen";
    }

    {
      mode = [ "n" "v" ];
      key = "<leader>e";
      action = "<cmd>keepjumps normal! G<CR>";
      options.desc = "Bottom of file";
    }


    {
      mode = [ "n" "v" ];
      key = "<leader>a";
      action = "<cmd>normal! ^<CR>";
      options.desc = "Start of line";
    }

    {
      mode = [ "n" "v" ];
      key = "<leader>s";
      action = "<cmd>normal! zz<CR>";
      options.desc = "Center line on screen";
    }

    {
      mode = [ "n" "v" ];
      key = "<leader>d";
      action = "<cmd>normal! $<CR>";
      options.desc = "End of line";
    }
  ];
}
