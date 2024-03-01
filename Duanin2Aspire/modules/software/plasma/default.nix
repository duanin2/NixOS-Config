{ pkgs, ... }: {
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
  ];

  services.xserver.displayManager.sddm = {
		enable = true;

		autoNumlock = true;
		wayland = {
			enable = true;

			#compositorCommand = "kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1";
		};
		settings = {
			General = {
				#GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
			};
		};
	};

  programs.kdeconnect.enable = true;

	programs.dconf.enable = true;
	services.fwupd.enable = true;
	chaotic.appmenu-gtk3-module.enable = true;
}