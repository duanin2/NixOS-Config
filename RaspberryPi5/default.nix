{ pkgs, inputs, lib, ... }: {
  imports = [
    # hardware
    ./modules/hardware/autoconfig
    ../common/modules/hardware/zram

    # software
    ../common/modules/software/nix
    ./modules/software/nix
    ../common/modules/software/localization
    ./modules/software/ssh
    ./modules/software/mesa
    ./modules/software/impermanence
    ../common/modules/software/home-manager
    ./modules/software/fuse
    ../common/modules/software/samba
    ./modules/software/mail

    # software/network
		../common/modules/software/network/networkmanager
		../common/modules/software/network/resolvd
		../common/modules/software/network/avahi
    ./modules/software/network/region

    # software/web
    ./modules/software/web/nginx
    # ./modules/software/web/transmission
    ./modules/software/web/invidious
    ./modules/software/web/aria2
    # ./modules/software/web/openvscode-server
    ./modules/software/web/searx
    ./modules/software/web/matrix
    ./modules/software/web/jellyfin

    # software/kernel
    ./modules/software/kernel/vendor-nixpkgs.nix

    # software/shell
    ../common/modules/software/shell/nushell.nix

    # software/bootloader
    ./modules/software/bootloader/grub

    ./duanin2
  ];

  environment.systemPackages = with pkgs; [ git ];

  boot.supportedFilesystems = [ "btrfs" ];

  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "RaspberryPi5";
	system.stateVersion = "23.11";
}
