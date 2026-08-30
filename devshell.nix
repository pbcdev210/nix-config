{ pkgs }:
pkgs.mkShell {
  formatter = pkgs.nixfmt-tree;
  nativeBuildInputs = [
    pkgs.nixd
    pkgs.uv
  ];
  shellHook = "";
}
