{ lib, ... }: {
  options.standalone = lib.mkOption {
    type = lib.types.bool;
    description = "When building home-manager in standalone mode, it evaluates to true, and vice versa";
  };

  options.profile = lib.mkOption {
    type = lib.types.str;
    description = "Profile name currently in use";
  };

  options.desktop = lib.mkOption {
    type = lib.types.str;
    description = "Desktop name currently in use";
  };

  options.name = lib.mkOption {
    type = lib.types.str;
    description = "Config name currently in use";
  };
}
