{ lib, ... }: {
	imports = [
		# hardware
		./modules/hardware/autoconfig
		./modules/hardware/efi
		./modules/hardware/nvidia
		./modules/hardware/bluetooth
		../common/modules/hardware/zram
		./modules/hardware/adb
		./modules/hardware/intel
    ../common/modules/hardware/steam-hardware

		# software
		../common/modules/software/nix
		./modules/software/printing
		../common/modules/software/localization
		../common/modules/software/appimage
		./modules/software/plymouth
		./modules/software/ssh
		./modules/software/protonmail
		./modules/software/git
		./modules/software/mesa
		./modules/software/gnupg
		../common/modules/software/samba
		./modules/software/impermanence
		./modules/software/nix
		../common/modules/software/home-manager
    ./modules/software/firejail
    ./modules/software/tlp
    ../common/modules/software/gnunet
    ../common/modules/software/kdeConnect
    ./modules/software/pipewire

		# software/network
		../common/modules/software/network/networkmanager
		../common/modules/software/network/firewall
		../common/modules/software/network/resolvd
		../common/modules/software/network/avahi
    ./modules/software/network/firewall
    ./modules/software/network/sysctl
    ./modules/software/network/nftables
    ./modules/software/network/resolvd
    ./modules/software/network/networkmanager
    ./modules/software/network/tor

		# software/network/vpn
		# ./modules/software/network/vpn/protonvpn.nix

		# software/kernel
		./modules/software/kernel/cachyos.nix

		# software/shell
		../common/modules/software/shell/nushell.nix

		# software/games
		./modules/software/games/steam
    ./modules/software/games/gamemode.nix
    ./modules/software/games/gamescope.nix
    ./modules/software/games/mangohud.nix

		# software/bootloader
		./modules/software/bootloader/systemd-boot

		# software/virtualization
		# ./modules/software/virtualization/waydroid
		# ./modules/software/virtualization/darling
    ./modules/software/virtualization/libvirt/default.nix

		# software/desktops
		# ./modules/software/desktop/plasma
		./modules/software/desktop/Hyprland
    # ./modules/software/desktop/QTile

		# software/greeters
		./modules/software/greeters/GreetD

		# software/theming
		./modules/software/theming

    # software/systemd
    ./modules/software/systemd/logind.nix
    ./modules/software/systemd/oomd.nix
    ./modules/software/systemd/sleep.nix
    
		./duanin2
	];

	boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];

  services.blueman.enable = true;

	networking.hostName = "Duanin2Aspire";
	system.stateVersion = "23.11";

	users.mutableUsers = false;
	boot.supportedFilesystems = [ "bcachefs" ];

	programs.fuse.userAllowOther = true;
}
