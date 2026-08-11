{ settings, ... }:
{
  programs.niri.settings.binds = {
    "Mod+Shift+E".action.quit = { };
    "Mod+grave".action.spawn = settings.tools.term;
    "Mod+Tab".action.toggle-overview = { };
  };

}
