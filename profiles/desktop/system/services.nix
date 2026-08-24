{ dirs, ... }: {
  imports = [
    "${dirs.system.services}/blueman"
    "${dirs.system.services}/caddy"
    "${dirs.system.services}/envfs"
    "${dirs.system.services}/flatpak"
    "${dirs.system.services}/iwd"
    "${dirs.system.services}/network-manager"
    "${dirs.system.services}/nginx"
    "${dirs.system.services}/ngrok"
    # "${dirs.system.services}/openssh"
    "${dirs.system.services}/pipewire"
    "${dirs.system.services}/systemd-resolved"
    "${dirs.system.services}/vaultwarden"
    "${dirs.system.services}/wayland"
    "${dirs.system.services}/xserver"
  ];
}
