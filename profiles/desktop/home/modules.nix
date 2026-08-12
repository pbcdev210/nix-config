{ dirs, ... }: {
  imports = [
    "${dirs.home.modules}/input-method"
    "${dirs.home.modules}/stylix"
    "${dirs.home.modules}/gtk"
  ];
}
