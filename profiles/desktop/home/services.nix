{ dirs, ... }:
{
  imports = [
    "${dirs.home.services}/copyq"
    "${dirs.home.services}/espanso"
  ];
}
