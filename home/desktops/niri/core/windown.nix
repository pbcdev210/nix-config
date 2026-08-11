{
  programs.niri.settings = {
    prefer-no-csd = true;

    window-rules = [
      {
        matches = [{ }];
        geometry-corner-radius = {
          top-left = 4.0;
          top-right = 4.0;
          bottom-left = 4.0;
          bottom-right = 4.0;
        };
        clip-to-geometry = true;
      }
    ];
  };
}
