{ settings, ... }:
{
  programs.niri.settings.binds = {
    "Mod+Shift+E".action.quit = { };
    "Mod+Q".action.spawn = settings.tools.term;
  };
}
