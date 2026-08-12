{ settings, ... }:
{
  networking.networkmanager = {
    enable = true;
    insertNameservers = settings.network.dns.ipv4 ++ settings.network.dns.ipv6;
    dns = "systemd-resolved";
    wifi.backend = "iwd";
  };
}
