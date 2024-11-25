{ pkgs, inputs, ... }: {
	environment.systemPackages = with pkgs; [
		applet-window-title
	] ++ (with pkgs.libsForQt5; [
		tokodon
		plasmatube
		bluedevil
		bluez-qt
	]);
	
	services.displayManager.defaultSession = "plasmawayland";

	services.desktopManager.plasma5.enable = true;

	programs.kdeconnect.package = lib.mkForce pkgs.libsForQt5.kdeconnect-kde;
}
