{ ... }: {
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

    # software/network
		../common/modules/software/network/networkmanager
		../common/modules/software/network/resolvd
		../common/modules/software/network/avahi

    # software/web
    ./modules/software/web/nginx
    ./modules/software/web/transmission
    ./modules/software/web/invidious

    # software/kernel
    ./modules/software/kernel/vendor-nixpkgs.nix

    # software/shell
    ../common/modules/software/shell/nushell.nix

    # software/bootloader
    ./modules/software/bootloader/grub

    ./duanin2
  ];

  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "RaspberryPi5";
	system.stateVersion = "23.11";
}
