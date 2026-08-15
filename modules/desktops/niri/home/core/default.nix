{
  programs.niri = {
    enable = true;
  };

  imports = [
    ./binds.nix
    ./windown
    ./inputs.nix
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.niri.settings.spawn-at-startup = [
    { command = [ "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" "NIRI_ID" ]; }
    { command = [ "systemctl" "--user" "import-environment" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" "NIRI_ID" ]; }
    { command = [ "systemctl" "--user" "restart" "graphical-session.target" ]; }
  ];

  stylix.targets.niri.enable = true;
}
