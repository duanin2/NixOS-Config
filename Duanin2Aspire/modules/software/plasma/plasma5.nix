{ pkgs, inputs, ... }: {
	environment.systemPackages = with pkgs; [
		(pkgs.callPackage ./sddm-catppuccin.nix { })

		(catppuccin-kde.override {
			flavour = [ "frappe" ];
			accents = [ "green" ];
		})

		blurredwallpaper

		applet-window-title
	] ++ (with pkgs.libsForQt5; [
		lightly

		tokodon
		plasmatube
		bluedevil
		bluez-qt
	]);

	services.xserver.displayManager.sddm = {
		theme = "catppuccin-sddm-frappe";
	};
	services.xserver.displayManager.defaultSession = "plasmawayland";

	services.xserver.desktopManager.plasma5.enable = true;
}