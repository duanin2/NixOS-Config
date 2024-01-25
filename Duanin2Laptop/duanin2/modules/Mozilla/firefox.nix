{ pkgs, ... }: {
	programs.firefox = {
		enable = true;
		package = (pkgs.callPackage ./common.nix { }) {
			package = pkgs.firefox_nightly.override {
				nativeMessagingHosts = with pkgs; [
					libsForQt5.plasma-browser-integration
					keepassxc
				];
			};
			src = pkgs.fetchurl {
				url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
				hash = "sha256-q11lngXIypp3EEF2Cgz8t8pMhVYDMvdVSKs1aa7i52s=";
			};
		};

		profiles = {
		  "default" = {
				bookmarks = [
					{
						name = "The toolbar";
						toolbar = true;
						bookmarks = [
							{
								name = "kernel.org";
								url = "https://www.kernel.org";
							}
							{
								name = "tio.run";
								url = "https://tio.run";
							}
							{
								name = "r/Piracy Megathread";
								url = "https://rentry.org/megathread";
							}
						];
					}
				];
				extensions = with pkgs.nur.repos.rycee.firefox-addons; [
					ublock-origin
					skip-redirect
					plasma-integration
					stylus
					firefox-color
					keepassxc-browser
					canvasblocker
					firemonkey
					libredirect
					indie-wiki-buddy
					auto-tab-discard
				];
				settings = {
					"widget.use-xdg-desktop-portal.file-picker" = 1;

					# Arkenfox overrides
					"browser.startup.page" = 3;
					"privacy.clearOnShutdown.history" = false;
					"webgl.disabled" = false;
				};
		  };
		};
	};
}