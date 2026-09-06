{ pkgs, ... }: {
  home.packages = [
    pkgs.dotnetCorePackages.sdk_10_0-bin
  ];
}
