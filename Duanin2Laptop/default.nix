{ ... }@specialArgs: {
	imports = [
		# hardware
		./modules/hardware/autoconfig
		./modules/hardware/efi
		./modules/hardware/nvidia
		./modules/hardware/bluetooth
		./modules/hardware/zram
		./modules/hardware/adb

		# software
		./modules/software/nix
		./modules/software/printing
		./modules/software/plasma
		./modules/software/localization
		./modules/software/appimage
		./modules/software/plymouth
		./modules/software/ssh
		./modules/software/waydroid

		# software/network
		./modules/software/network/networkmanager
		./modules/software/network/firewall
		./modules/software/network/resolvd
		./modules/software/network/avahi

		# software/kernel
		./modules/software/kernel/cachyos-schedext.nix

		# software/shell
		./modules/software/shell/nushell.nix

		# software/games
		./modules/software/games/steam

		# software/sound
		./modules/software/sound
		./modules/software/sound/pipewire

		# software/bootloader
		./modules/software/bootloader/systemd-boot

		./duanin2
	];

	networking.hostName = "Duanin2Aspire";
	system.stateVersion = "24.05";
}
