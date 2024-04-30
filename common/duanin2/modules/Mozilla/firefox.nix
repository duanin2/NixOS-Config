{ lib, config, nur, customPkgs, pkgs, inputs, persistDirectory, ... }: {
	programs.firefox = {
		enable = true;
		package = customPkgs.mozilla.addUserJsPrefs {
			package = pkgs.firefox;
			src = pkgs.fetchurl {
				url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
				hash = "sha256-H3Nk5sDxSElGRgK+cyQpVyjtlMF2Okxbstu9A+eJtGk=";
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
				extensions = with nur.repos.rycee.firefox-addons; [
					ublock-origin
					skip-redirect
					stylus
					firefox-color
					canvasblocker
					firemonkey
					libredirect
					indie-wiki-buddy
					auto-tab-discard
					steam-database
					terms-of-service-didnt-read
					unpaywall
					wayback-machine
				]
				++ (with customPkgs.mozilla.firefoxAddons; [
					librejs
				]);
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

	home.persistence.${persistDirectory} = {
    directories = [ ".mozilla" ];
  };
}