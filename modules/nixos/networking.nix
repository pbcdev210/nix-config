{ settings, config, ... }:
{
  networking = {
    nameservers = settings.network.dns.ipv4 ++ settings.network.dns.ipv6;

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
      ];
      allowedUDPPorts = [ 51820 ];
    };

    nftables = {
      enable = true;
      flushRuleset = false;
    };

    networkmanager = {
      enable = true;
      insertNameservers = settings.network.dns.ipv4 ++ settings.network.dns.ipv6;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };

    wireless = {
      enable = false;
      iwd = {
        enable = true;
        settings = {
          Settings.AutoConnect = true;
          Network.EnableIPv6 = true;
        };
      };
    };
  };

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSSEC = "allow-downgrade";
        DNSOverTLS = true;
        DNS = config.networking.nameservers;
      };
    };
  };
}
