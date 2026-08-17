{ dirs, ... }: {
  imports = [
    "${dirs.home.modules}/input-method"
    "${dirs.home.modules}/gtk"
    "${dirs.home.modules}/stylix"
    "${dirs.home.modules}/systemd"

    "${dirs.modules}/sops"
  ];
}
