{
  programs.mpvpaper = {
    enable = true;
  };

  programs.niri.settings = {
    spawn-at-startup = [
      {
        argv = [
          "mpvpaper"
          "-o"
          "no-audio loop panscan=1.0"
          "*"
          "/workspaces/nix-config/assets/kawaii-cat-girl.png"
        ];
      }
    ];
  };
}
