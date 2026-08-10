{
  imports = [
    ./clipboard.nix
    ./history.nix
    ./motions.nix
  ];

  programs.nixvim.keymaps = [
    {
      mode = "i";
      key = "<C-BS>";
      action = "<cmd>normal! db<CR>";
      options = {
        silent = true;
        desc = "Delete inner word with Ctrl+Backspace";
      };
    }
  ];
}
