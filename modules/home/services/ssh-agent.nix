{ settings, dirs, ... }:
{
  services.ssh-agent = {
    enable = true;
  };

  sops.secrets."ssh/main" = {
    path = "/home/${settings.identity.username}/.ssh/id_ed25519";
  };

  home.file.".ssh/id_ed25519.pub".source = "${dirs.data}/ssh.pub";
}
