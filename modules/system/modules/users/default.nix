{ pkgs, settings, config, ... }: {
  users.users.${settings.identity.username} = {
    isNormalUser = true;
    description = "user main";
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "uinput"
    ];
    shell = pkgs."${settings.tools.shell}";
    home = settings.dirs.home;
    hashedPasswordFile = config.sops.secrets."hashedPassword".path;
  };
}
