{
  programs.niri.settings = {
    prefer-no-csd = true;

    window-rules = [
      {
        matches = [{ }];
        geometry-corner-radius = {
          top-left = 2.0;
          top-right = 2.0;
          bottom-left = 2.0;
          bottom-right = 2.0;
        };
        clip-to-geometry = true;
      }
    ];
  };
}
