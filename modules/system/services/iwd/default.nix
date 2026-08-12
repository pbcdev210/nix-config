{
  networking.wireless = {
    enable = false;
    iwd = {
      enable = true;
      settings = {
        Settings.AutoConnect = true;
        Network.EnableIPv6 = true;
      };
    };
  };
}
