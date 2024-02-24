{ ... }: {
  imports = [
    # hardware
    ../common/modules/hardware/zram

    # software
    ../common/modules/software/nix
    ../common/modules/software/localization

    # software/network
		../common/modules/software/network/networkmanager
		../common/modules/software/network/resolvd
		../common/modules/software/network/avahi

    # software/kernel
    ./modules/software/kernel/vendor.nix

    # software/shell
    ../common/modules/software/shell/nushell.nix

    # software/bootloader
    ./modules/software/bootloader/grub
  ];

  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "Duanin2Aspire";
	system.stateVersion = "24.05";
}