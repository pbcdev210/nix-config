{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
    allowedUDPPorts = [ 51820 ];
  };
  networking.nftables = {
    enable = true;
    flushRuleset = false;
  };
}
