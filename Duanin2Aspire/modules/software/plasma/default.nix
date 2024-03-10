{ lib, pkgs, ... }: let
	sddm-numlock = pkgs.writeFile "sddm-numlock-fix" ''
	[Keyboard]
	NumLock=0
	'';
in {
  imports = [
    ../X
    ./plasma6.nix
  ];

  environment.systemPackages = with pkgs; [
    (catppuccin-gtk.override {
			variant = "frappe";
			accents = [ "green" ];
		})
		catppuccin-cursors.frappeGreen
		(catppuccin-papirus-folders.override {
			flavor = "frappe";
			accent = "green";
		})

    clinfo
		mesa-demos
		vulkan-tools
		wayland-utils
		pciutils

		(pkgs.callPackage ./sddm-catppuccin.nix { })

		(catppuccin-kde.override {
			flavour = [ "frappe" ];
			accents = [ "green" ];
		})

		lightly-qt
  ];

  services.xserver.displayManager.sddm = {
		enable = true;

		theme = "catppuccin-sddm-frappe";
		autoNumlock = true;
		wayland = {
			enable = true;

			compositorCommand = "kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1";
		};
		settings = {
			General = {
				GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
			};
		};
	};

	system.activationScripts."sddm-numlock-fix" = {
		deps = [ "var" ];
		text = ''
    mkdir -p /var/lib/sddm/.config
		ln -s ${sddm-numlock} /var/lib/sddm/.config/kcminputrc
  	'';
	};

  programs.kdeconnect.enable = true;

	programs.dconf.enable = true;
	services.fwupd.enable = true;
	chaotic.appmenu-gtk3-module.enable = true;
}