{
  programs.nixvim.colorschemes.tokyonight = {
    enable = false;

    settings = {
      style = "night";
      terminal_colors = true;
      styles = {
        comments.italic = true;
        keywords.italic = true;
        functions.bold = true;
      };
    };
  };
}
