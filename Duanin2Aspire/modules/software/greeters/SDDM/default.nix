{ pkgs, ... }: let
	sddm-numlock = pkgs.writeText "sddm-numlock-fix" ''
	[Keyboard]
	NumLock=0
	'';
in {
  # environment.systemPackages = with pkgs; [ (pkgs.callPackage ./sddm-catppuccin.nix { }) ];

  services.xserver.displayManager.sddm = {
		enable = true;

		# theme = "catppuccin-sddm-frappe";
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
}
