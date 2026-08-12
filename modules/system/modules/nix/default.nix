{ lib, settings, ... }:
{
  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ settings.identity.username ];
    experimental-features = [ "nix-command" "flakes" ];

    trusted-substituters = [
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
    persistent = true;
    randomizedDelaySec = "45min";
  };

  nix.firewall = {
    enable = true;
    allowLoopback = true;
    allowNonTCPUDP = false;
    allowPrivateNetworks = false;
  };

  nix.extraOptions = lib.readFile ./nix.conf;
}
