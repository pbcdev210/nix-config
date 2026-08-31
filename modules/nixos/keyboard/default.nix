{
  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        devices = [ "/dev/input/by-id/usb-Compx_2.4G_Wireless_Receiver-event-kbd" ];
        extraDefCfg = "concurrent-tap-hold yes";
        config = builtins.readFile ./kanata.kbd;
      };
    };
  };
}
