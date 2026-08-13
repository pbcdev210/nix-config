{ dirs, ... }: {
  imports = [
    "${dirs.home.modules}/input-method"
    "${dirs.home.modules}/gtk"
    
    "${dirs.modules}/sops"
  ];
}
