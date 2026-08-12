{ config, ... }:
{
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
