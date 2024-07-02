{ lib, config, nur, customPkgs, pkgs, inputs, persistDirectory, ... }: {
  disabledModules = [ ./firefox.nix ];
  
	programs.firefox = {
		enable = true;
    package = pkgs.mullvad-browser;

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
        search = rec {
          engines = {
            "SearXNG" = {
              urls = [
                {
                  template = "https://searx.duanin2.top/search";
                  params = [
                    { name = "q"; value = "{searchTerms}"; }
                  ];
                }
              ];
              icon = "${pkgs.searxng}/share/static/themes/simple/img/favicon.svg";
            };
          };
          force = true;
          default = "SearXNG";
          privateDefault = default;
        };
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
					# steam-database
					terms-of-service-didnt-read
					unpaywall
					wayback-machine
          # tabcenter-reborn
				]
				++ (with customPkgs.mozilla.firefoxAddons; [
					librejs
				]);
				settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          
					# Arkenfox overrides
          # "browser.startup.page" = 3;
          # "privacy.clearOnShutdown.history" = false;
					"webgl.disabled" = false;
          # "privacy.resistFingerprinting" = false;
          # "privacy.resistFingerprinting.letterboxing" = false;
				};
		  };
		};
	};

	home.persistence.${persistDirectory} = {
    directories = [ ".mullvad" ];
  };
}
