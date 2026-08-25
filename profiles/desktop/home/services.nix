{ dirs, ... }:
{
  imports = [
    "${dirs.home.services}/audio-ducking"
    "${dirs.home.services}/clipse"
    # "${dirs.home.services}/copyq"
    # "${dirs.home.services}/espanso"
  ];
}
