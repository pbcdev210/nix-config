{
  programs.nixvim = {
    globals.mapleader = " ";

    keymaps = [
      {
        mode = "n";
        key = ";";
        action = ":";
      }
    ];
  };
}
