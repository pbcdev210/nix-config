{
  programs.niri.settings.binds = {
    "XF86AudioRaiseVolume" = {
      allow-when-locked = true;
      action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" ];
    };
    "XF86AudioLowerVolume" = {
      allow-when-locked = true;
      action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" ];
    };
    "XF86AudioMute" = {
      allow-when-locked = true;
      action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
    };
    "XF86AudioMicMute" = {
      allow-when-locked = true;
      action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
    };
    "XF86AudioPlay" = {
      allow-when-locked = true;
      action.spawn = [ "playerctl" "--player" "spotify" "play-pause" ];
    };
    "XF86AudioStop" = {
      allow-when-locked = true;
      action.spawn = [ "playerctl" "--player" "spotify" "stop" ];
    };
    "XF86AudioPrev" = {
      allow-when-locked = true;
      action.spawn = [ "playerctl" "--player" "spotify" "previous" ];
    };
    "XF86AudioNext" = {
      allow-when-locked = true;
      action.spawn = [ "playerctl" "--player" "spotify" "next" ];
    };
  };
}
