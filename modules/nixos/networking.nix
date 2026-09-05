{
  config,
  ...
}:
{
  networking = {
    hostName = config.name;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "2606:4700:4700::1111"
      "2001:4860:4860::8888"
    ];

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
      ];
      allowedUDPPorts = [ 51820 ]; # WireGuard
    };

    nftables = {
      enable = true;
      flushRuleset = false;
    };

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };

    wireless.enable = false;
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    settings = {
      Resolve.DNSOverTLS = "true";
    };
  };
}
