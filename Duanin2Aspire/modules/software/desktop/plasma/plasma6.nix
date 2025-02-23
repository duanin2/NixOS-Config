{ inputs, pkgs, lib, ... }: {
	services.desktopManager.plasma6.enable = true;

	services.displayManager.defaultSession = "plasma";

	environment.systemPackages = with pkgs; [
		plasma-plugin-blurredwallpaper
	] ++ (with pkgs.kdePackages; [
		tokodon
		plasmatube
		kjournald
		bluedevil
		bluez-qt

		#applet-window-buttons6
		applet-window-title
	]);

	security.pam.services.kwallet = {
		name = "kwallet";
		enableKwallet = true;
	};

	programs.kdeconnect.package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;
}
