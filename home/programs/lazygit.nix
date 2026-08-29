{
  programs.lazygit = {
    enable = true;

    settings = {
      gui = {
        language = "en";
        showIcons = true;
      };

      git = {
        autoFetch = true;
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never --line-numbers";
          }
        ];
      };
    };
  };

  stylix.targets.lazygit.enable = true;
}
