{ lib, ... }: {

  options.desktop = lib.mkOption {
    type = lib.types.str;
    description = "Desktop name currently in use";
  };

  options.profile = lib.mkOption {
    type = lib.types.str;
    description = "Profile name currently in use";
  };

  options.host = lib.mkOption {
    type = lib.types.str;
    description = "Host name currently in use";
  };

  options.name = lib.mkOption {
    type = lib.types.str;
    description = "Config name currently in use";
  };
}
