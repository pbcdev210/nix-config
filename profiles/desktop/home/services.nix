{ dirs, ... }:
{
  imports = [
    "${dirs.home.services}/clipse"
    # "${dirs.home.services}/copyq"
    "${dirs.home.services}/espanso"
  ];
}
