{ modules, ... }: {
	imports = [
		# hardware
		(modules.local.hardware + /autoconfig)
		(modules.local.hardware + /efi)
		(modules.local.hardware + /nvidia)
		(modules.local.hardware + /bluetooth)
		(modules.common.hardware + /zram)
		(modules.local.hardware + /adb)
		(modules.local.hardware + /intel)
    (modules.common.hardware + /steam-hardware)

		# software
		(modules.common.software + /nix)
		(modules.local.software + /printing)
		(modules.common.software + /localization)
		(modules.common.software + /appimage)
		#(modules.local.software + /plymouth)
		(modules.local.software + /ssh)
		#(modules.local.software + /protonmail)
		(modules.local.software + /git)
		(modules.local.software + /mesa)
		(modules.local.software + /gnupg)
		(modules.common.software + /samba)
		(modules.local.software + /impermanence)
		(modules.local.software + /nix)
		(modules.common.software + /home-manager)
    #(modules.local.software + /firejail)
    #(modules.local.software + /tlp)
    (modules.common.software + /kdeConnect)
    (modules.local.software + /pipewire)
    (modules.common.software + /nix-ld)
    (modules.common.software + /chrony)

		# software.network
    (modules.common.software.network + /avahi)
		#(modules.common.software.network + /vpn/protonvpn.nix)
    #(modules.common.software.network + /miredo)
    (modules.common.software.network + /firewall)
    (modules.common.software.network + /resolvd)
    (modules.common.software.network + /networkmanager)
    (modules.common.software.network + /gnunet)

		# software.kernel
		(modules.common.software.kernel + /cachyos.nix)

		# software.shell
		(modules.common.software.shell + /nushell.nix)

		# software.games
		(modules.local.software.games + /steam)
    (modules.local.software.games + /gamemode.nix)
    (modules.local.software.games + /gamescope.nix)
    (modules.local.software.games + /mangohud.nix)

		# software.bootloader
		#(modules.local.software.bootloader + /systemd-boot)
		(modules.local.software.bootloader + /grub)

		# software.virtualization
		#(modules.local.software.virtualization + /waydroid)
		#(modules.local.software.virtualization + /darling)
    (modules.local.software.virtualization + /libvirt)

		# software.desktops
		(modules.local.software.desktops + /plasma)
		#(modules.local.software.desktops + /Hyprland)
    #(modules.local.software.desktops + /QTile)

		# software.greeters
		#(modules.local.software.greeters + /GreetD)
    (modules.local.software.greeters + /SDDM)

		# software.theming
		(modules.local.software.theming)

    # software.systemd
    (modules.local.software + /systemd/logind.nix)
    (modules.local.software + /systemd/oomd.nix)
    (modules.local.software + /systemd/sleep.nix)
    
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
