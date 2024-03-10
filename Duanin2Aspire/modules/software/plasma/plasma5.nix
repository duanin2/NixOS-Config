{ pkgs, inputs, ... }: {
	environment.systemPackages = with pkgs; [
		applet-window-title
	] ++ (with pkgs.libsForQt5; [
		tokodon
		plasmatube
		bluedevil
		bluez-qt
	]);
	
	services.xserver.displayManager.defaultSession = "plasmawayland";

	services.xserver.desktopManager.plasma5.enable = true;
}