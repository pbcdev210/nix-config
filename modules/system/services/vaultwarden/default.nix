{ pkgs, settings, config, ... }:
let
  repoBot = settings.dirs.nixConfigBot;
  dbFile = "${config.services.vaultwarden.backupDir}/db.sqlite3";
  rsaFile = "${config.services.vaultwarden.backupDir}/rsa_key.pem";

  hashFile = "${repoBot}/secrets/vaultwarden.sha256";
  encryptedBackup = "${repoBot}/secrets/vaultwarden.backup.tar.gz.age";
in
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

    backupDir = "/var/backup/vaultwarden";
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

  systemd.services.vaultwarden-backup-github = {
    description = "Vaultwarden Backup";
    after = [ "network.target" "vaultwarden.service" ];

    script = ''
      set -e

      if [ ! -f "${dbFile}" ]; then
          echo "ERROR: ${dbFile} not fond"
          exit 1
      fi

      if [ ! -f "${rsaFile}" ]; then
        echo "ERROR: ${rsaFile} not fond"
        exit 1
      fi

      if ! ${pkgs.sudo}/bin/sudo -u ${settings.identity.username} ${pkgs.git}/bin/git -C "${repoBot}" rev-parse --git-dir > /dev/null 2>&1; then
        rm -rf "${repoBot}"
        echo "INFO: Clone repo ${settings.repo.github}"
        ${pkgs.sudo}/bin/sudo -u ${settings.identity.username} ${pkgs.git}/bin/git clone ${settings.repo.github} ${repoBot}
      else
        ${pkgs.sudo}/bin/sudo -u ${settings.identity.username} ${pkgs.git}/bin/git -C "${repoBot}" fetch

        if [ "$(${pkgs.sudo}/bin/sudo -u ${settings.identity.username} ${pkgs.git}/bin/git -C "${repoBot}" rev-parse HEAD)" != "$(${pkgs.sudo}/bin/sudo -u ${settings.identity.username} ${pkgs.git}/bin/git -C "${repoBot}" rev-parse @{u})" ]; then
          echo "INFO: Pull repo ${repoBot}"
          ${pkgs.sudo}/bin/sudo -u ${settings.identity.username} ${pkgs.git}/bin/git -C "${repoBot}" pull
        fi
      fi

      CURRENT_HASH=$(${pkgs.coreutils}/bin/cat "${dbFile}" "${rsaFile}" | ${pkgs.coreutils}/bin/sha256sum | ${pkgs.gawk}/bin/awk '{print $1}')

      OLD_HASH=""
      if [ -f "${hashFile}" ]; then
          OLD_HASH=$(${pkgs.gawk}/bin/awk '{print $1}' "${hashFile}")
      fi

      echo "INFO: Current hash: $CURRENT_HASH"
      echo "INFO: Old hash: $OLD_HASH"

      if [ "$CURRENT_HASH" != "$OLD_HASH" ]; then
          echo "INFO: Database changed!"

          echo "$CURRENT_HASH" > "${hashFile}"
          ${pkgs.gnutar}/bin/tar cf - \
              -C ${config.services.vaultwarden.backupDir} \
              db.sqlite3 rsa_key.pem | \
          ${pkgs.gzip}/bin/gzip > /tmp/vaultwarden-core.tar.gz

          ${pkgs.age}/bin/age -e -r ${settings.age.publicKey} -o "${encryptedBackup}" /tmp/vaultwarden-core.tar.gz

          rm /tmp/vaultwarden-core.tar.gz

          chown ${settings.identity.username}:wheel "${encryptedBackup}" "${hashFile}"

          ${pkgs.sudo}/bin/sudo -u ${settings.identity.username} ${pkgs.bash}/bin/bash << EOF
            cd ${repoBot}

            ${pkgs.git}/bin/git reset
            ${pkgs.git}/bin/git add ${encryptedBackup} ${hashFile}

            ${pkgs.git}/bin/git commit -m "[bot] update vaultwarden backup
            time: \$(date +'%Y-%m-%d %H:%M:%S')"
            ${pkgs.git}/bin/git push origin main
            echo "INFO: Push on github"
      EOF
      else
        echo "INFO: Database unchanged"
      fi
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers.vaultwarden-backup-github = {
    description = "Timer for automated Vaultwarden backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "15min";
      OnUnitActiveSec = "72h";
      Persistent = true;
    };
  };
}
