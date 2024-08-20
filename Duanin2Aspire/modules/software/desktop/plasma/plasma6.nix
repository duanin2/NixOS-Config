{ inputs, pkgs, lib, ... }: {
	services.desktopManager.plasma6.enable = true;

	services.displayManager.defaultSession = "plasma";

	environment.systemPackages = with pkgs; [
		plasma-plugin-blurredwallpaper
		
		(applet-window-title.overrideAttrs (old: let 
			pname = "applet-window-title6";
			version = "master";
		in {
			inherit pname version;

			src = fetchFromGitHub {
				owner = "moodyhunter";
				repo = pname;
				rev = version;
				hash = "sha256-5V1FMTG7pITI+4IZE1vzOGL27nrWTWQltVIQpXD3uj4=";
			};

			meta = with lib; {
				description = "Plasma 6 applet that shows the application title and icon for active window";
				homepage = "https://github.com/moodyhunter/applet-window-title6";
			};
		}))
	] ++ (with pkgs.kdePackages; [
		tokodon
		plasmatube
		kjournald
		bluedevil
		bluez-qt
	]);

	security.pam.services.kwallet = {
		name = "kwallet";
		enableKwallet = true;
	};
}
