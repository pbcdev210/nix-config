{ pkgs }:
pkgs.mkShell {
  formatter = pkgs.nixfmt-tree;
  nativeBuildInputs = [
    pkgs.nixd
    # pkgs.nh
    # pkgs.home-manager
    pkgs.uv
  ];
  shellHook = "";
}
