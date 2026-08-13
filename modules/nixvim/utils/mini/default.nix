{
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      pairs = { };
      surround = { };
      ai = { };
      comment = { };
      indentscope = {
        symbol = "┆";
      };
      splitjoin = { };
      hipatterns = { };
      clue = { };
    };
  };
}
