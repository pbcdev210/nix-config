{ pkgs, ... }:
{
  systemd.user.services.audio-ducking = {
    Unit = {
      Description = "Smart Audio Ducking Service (PipeWire/WirePlumber)";
      After = [ "pipewire.service" "wireplumber.service" ];
      Wants = [ "pipewire.service" "wireplumber.service" ];
    };

    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.myPkgs.audio-ducking}/bin/audio-ducking \
          --source-a "spotify" \
          --source-b "*" \
          --duck-vol 0.50 \
          --check-interval 0.2 \
          --grace-period 1.5
      '';

      Restart = "on-failure";
      RestartSec = "5s";

      StandardOutput = "journal";
      StandardError = "journal";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
