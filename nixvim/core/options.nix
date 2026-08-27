{
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;
    modeline = false;

    signcolumn = "yes";
    cursorline = true;

    shiftwidth = 2;
    tabstop = 2;
    expandtab = true;
    smartindent = true;

    ignorecase = true;
    smartcase = true;

    clipboard = "unnamedplus";
    undofile = true;

    updatetime = 300;
    mouse = "a";
  };
}
