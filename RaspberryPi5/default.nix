{ pkgs, modules, ... }: {
  imports = [
    # hardware
    (modules.local.hardware + /autoconfig)
    (modules.common.hardware + /zram)

    # software
    (modules.common.software + /nix)
    (modules.local.software + /nix)
    (modules.common.software + /localization)
    (modules.local.software + /ssh)
    (modules.local.software + /mesa)
    (modules.local.software + /impermanence)
    (modules.common.software + /home-manager)
    (modules.local.software + /fuse)
    (modules.common.software + /samba)
    (modules.local.software + /mail)
    (modules.common.software + /nix-ld)
    (modules.common.software + /chrony)

    # software/network
    (modules.common.software.network + /networkmanager)
    #(modules.common.software.network + /resolvd)
    (modules.common.software.network + /avahi)
    (modules.local.software.network + /region)
    (modules.common.software.network + /miredo)
    #(modules.common.software.network + /dnsmasq)
    (modules.common.software.network + /unbound)

    # software/web
    (modules.local.software.web + /nginx)
    #(modules.local.software.web + /transmission)
    #(modules.local.software.web + /invidious)
    (modules.local.software.web + /aria2)
    #(modules.local.software.web + /openvscode-server)
    (modules.local.software.web + /searx)
    (modules.local.software.web + /matrix)
    (modules.local.software.web + /jellyfin)
    (modules.local.software.web + /ntfy)
    (modules.local.software.web + /anki)

    # software/kernel
    (modules.common.software.kernel.RaspberryPi + /vendor-nixpkgs.nix)

    # software/shell
    (modules.common.software.shell + /nushell.nix)

    # software/bootloader
    (modules.local.software.bootloader + /grub)

    ./duanin2
  ];

  environment.systemPackages = with pkgs; [ git ];

  boot.supportedFilesystems = [ "btrfs" ];

  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "RaspberryPi5";
	system.stateVersion = "23.11";
}
