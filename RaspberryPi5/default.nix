{ ... }: {
  imports = [
    # hardware
    ./modules/hardware/autoconfig
    ../common/modules/hardware/zram

    # software
    ../common/modules/software/nix
    ../common/modules/software/localization
    ./modules/software/ssh

    # software/network
		../common/modules/software/network/networkmanager
		../common/modules/software/network/resolvd
		../common/modules/software/network/avahi

    # software/web
    ./modules/software/network/nginx
    ./modules/software/network/transmission
    ./modules/software/network/invidious

    # software/kernel
    ./modules/software/kernel/vendor.nix

    # software/shell
    ../common/modules/software/shell/nushell.nix

    # software/bootloader
    ./modules/software/bootloader/grub

    ./duanin2
  ];

  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "RaspberryPi5";
	system.stateVersion = "24.05";
}