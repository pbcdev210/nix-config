{ pkgs, ... }:
let
  volumeControl = pkgs.myScripts.volume-control;
  brightnessControl = pkgs.myScripts.brightness-control;
  player-control = "${pkgs.playerctl}/bin/playerctl";
in
{
  programs.niri.settings.binds = {
    "XF86AudioRaiseVolume" = {
      allow-when-locked = true;
      action.spawn = [
        "${volumeControl}/bin/volume-control"
        "--inc"
      ];
    };
    "XF86AudioLowerVolume" = {
      allow-when-locked = true;
      action.spawn = [
        "${volumeControl}/bin/volume-control"
        "--dec"
      ];
    };
    "XF86AudioMute" = {
      allow-when-locked = true;
      action.spawn = [
        "${volumeControl}/bin/volume-control"
        "--toggle"
      ];
    };
    "XF86AudioMicMute" = {
      allow-when-locked = true;
      action.spawn = [
        "${volumeControl}/bin/volume-control"
        "--toggle-mic"
      ];
    };

    "XF86AudioPlay" = {
      allow-when-locked = true;
      action.spawn = [ player-control "--player=spotify" "play-pause" ];
    };
    "XF86AudioStop" = {
      allow-when-locked = true;
      action.spawn = [ player-control "--player=spotify" "stop" ];
    };
    "XF86AudioPrev" = {
      allow-when-locked = true;
      action.spawn = [ player-control "--player=spotify" "previous" ];
    };
    "XF86AudioNext" = {
      allow-when-locked = true;
      action.spawn = [ player-control "--player=spotify" "next" ];
    };

    "XF86MonBrightnessUp" = {
      allow-when-locked = true;
      action.spawn = [ "${brightnessControl}/bin/brightness-control" "--inc" ];
    };
    "XF86MonBrightnessDown" = {
      allow-when-locked = true;
      action.spawn = [ "${brightnessControl}/bin/brightness-control" "--dec" ];
    };

    "XF86HomePage" = {
      allow-when-locked = true;
      action.spawn = [ "${brightnessControl}/bin/brightness-control" "--inc" ];
    };
    "XF86Mail" = {
      allow-when-locked = true;
      action.spawn = [ "${brightnessControl}/bin/brightness-control" "--dec" ];
    };
  };
}
