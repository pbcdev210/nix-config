{ settings, pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    qemu
    OVMF
  ];

  users.users.${settings.identity.username}.extraGroups = [ "libvirtd" ];
  programs.dconf.enable = true;
}
