{ ... }@specialArgs: {
	imports = [
		# hardware
		./modules/hardware/autoconfig
		./modules/hardware/efi
		# ./modules/hardware/nvidia
		./modules/hardware/bluetooth
		./modules/hardware/zram
		./modules/hardware/adb
		./modules/hardware/intel

		# software
		./modules/software/nix
		./modules/software/printing
		./modules/software/plasma
		./modules/software/localization
		./modules/software/appimage
		./modules/software/plymouth
		./modules/software/ssh
		./modules/software/protonmail
		./modules/software/git
		./modules/software/mesa

		# software/network
		./modules/software/network/networkmanager
		./modules/software/network/firewall
		./modules/software/network/resolvd
		./modules/software/network/avahi

		# software/network/vpn
		# ./modules/software/network/vpn/protonvpn.nix

		# software/kernel
		./modules/software/kernel/cachyos.nix

		# software/shell
		./modules/software/shell/nushell.nix

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
