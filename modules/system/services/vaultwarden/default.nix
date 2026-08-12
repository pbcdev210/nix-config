{ pkgs, settings, ... }:
{
  services.vaultwarden = {
    enable = true;

    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;

      DOMAIN = "https://glider-crafter-retrace.ngrok-free.dev";

      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;
    };
  };

  systemd.services.ngrok-vaultwarden = {
    description = "Ngrok Tunnel for Vaultwarden";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ngrok}/bin/ngrok http 8222 --domain=glider-crafter-retrace.ngrok-free.dev";
      Restart = "always";
      User = settings.identity.username;
    };
  };
}
