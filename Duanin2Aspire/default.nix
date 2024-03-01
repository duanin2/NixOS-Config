{ ... }@specialArgs: {
	imports = [
		# hardware
		./modules/hardware/autoconfig
		./modules/hardware/efi
		# ./modules/hardware/nvidia
		./modules/hardware/bluetooth
		../common/modules/hardware/zram
		./modules/hardware/adb
		./modules/hardware/intel

		# software
		../common/modules/software/nix
		./modules/software/printing
		./modules/software/plasma
		../common/modules/software/localization
		../common/modules/software/appimage
		./modules/software/plymouth
		./modules/software/ssh
		./modules/software/protonmail
		./modules/software/git
		./modules/software/mesa

		# software/network
		../common/modules/software/network/networkmanager
		../common/modules/software/network/firewall
		../common/modules/software/network/resolvd
		../common/modules/software/network/avahi

		# software/network/vpn
		# ./modules/software/network/vpn/protonvpn.nix

		# software/kernel
		./modules/software/kernel/cachyos.nix

		# software/shell
		../common/modules/software/shell/nushell.nix

		# software/games
		./modules/software/games/steam

		# software/sound
		./modules/software/sound
		./modules/software/sound/pipewire

		# software/bootloader
		./modules/software/bootloader/systemd-boot

		# software/virtualization
		./modules/software/virtualization/waydroid
		./modules/software/virtualization/darling

		./duanin2
	];

	networking.hostName = "Duanin2Aspire";
	system.stateVersion = "24.05";
}
