{ pkgs, dirs, ... }:
let
  sh = "${pkgs.bash}/bin/sh";
  volumeControl = import ./scripts/volume-control.nix { inherit pkgs dirs; };
in
{
  programs.niri.settings.binds = {
    "XF86AudioRaiseVolume" = {
      allow-when-locked = true;
      action.spawn = [
        "${sh}"
        "-c"
        "${volumeControl}/bin/volume-control --inc"
      ];
    };
    "XF86AudioLowerVolume" = {
      allow-when-locked = true;
      action.spawn = [
        "${sh}"
        "-c"
        "${volumeControl}/bin/volume-control --dec"
      ];
    };
    "XF86AudioMute" = {
      allow-when-locked = true;
      action.spawn = [
        "${sh}"
        "-c"
        "${volumeControl}/bin/volume-control --toggle"
      ];
    };
    "XF86AudioMicMute" = {
      allow-when-locked = true;
      action.spawn = [
        "${sh}"
        "-c"
        "${volumeControl}/bin/volume-control --toggle-mic"
      ];
    };

    "XF86AudioPlay" = {
      allow-when-locked = true;
      action.spawn = [ "playerctl" "play-pause" ];
    };
    "XF86AudioStop" = {
      allow-when-locked = true;
      action.spawn = [ "playerctl" "stop" ];
    };
    "XF86AudioPrev" = {
      allow-when-locked = true;
      action.spawn = [ "playerctl" "previous" ];
    };
    "XF86AudioNext" = {
      allow-when-locked = true;
      action.spawn = [ "playerctl" "next" ];
    };
  };
}
