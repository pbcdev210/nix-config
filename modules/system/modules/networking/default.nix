{ settings, ... }:
{
  networking = {
    nameservers = settings.network.dns.ipv4 ++ settings.network.dns.ipv6;
  };
  imports = [ ./firewall.nix ];
}
