{
  programs.wezterm = {
    enable = true;

    settings = {
      front_end = "WebGpu";
      window_decorations = "RESIZE";

      hide_tab_bar_if_only_one_tab = true;
      use_fancy_tab_bar = false;
    };

    extraConfig = builtins.readFile ./wezterm.lua;
  };

  stylix.targets.wezterm.enable = true;
}

