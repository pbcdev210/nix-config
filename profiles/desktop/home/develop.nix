{ dirs, ... }:
{
  imports = [
    "${dirs.home.develop}/android"
    "${dirs.home.develop}/dotnet"
  ];
}
