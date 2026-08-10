{
  programs.nixvim.keymaps = [
    {
      mode = "v";
      key = "<C-c>";
      action = "<CMD>lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('\"+y', true, false, true), 'n', false)<CR>";
      options = {
        silent = true;
        desc = "Copy selection to system clipboard";
      };
    }

    {
      mode = "n";
      key = "<C-v>";
      action = "<CMD>put +<CR>";
      options = {
        silent = true;
        desc = "Paste from system clipboard";
      };
    }

    {
      mode = "i";
      key = "<C-v>";
      action = "<CMD>lua vim.api.nvim_put({vim.fn.getreg('+')}, 'c', true, true)<CR>";
      options = {
        silent = true;
        desc = "Paste from system clipboard in insert mode";
      };
    }

    {
      mode = "v";
      key = "<C-v>";
      action = "<CMD>lua vim.api.nvim_feedkeys('d', 'x', false); vim.api.nvim_put({vim.fn.getreg('+')}, 'c', true, true)<CR>";
      options = {
        silent = true;
        desc = "Paste and replace selection";
      };
    }

    {
      mode = "v";
      key = "<C-x>";
      action = "<CMD>lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('\"+d', true, false, true), 'n', false)<CR>";
      options = {
        silent = true;
        desc = "Cut selection to system clipboard";
      };
    }
  ];
}
