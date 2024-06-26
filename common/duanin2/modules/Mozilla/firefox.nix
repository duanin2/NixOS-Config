{ lib, config, nur, customPkgs, pkgs, inputs, persistDirectory, ... }: {
	programs.firefox = {
		enable = true;
		package = customPkgs.mozilla.addUserJsPrefs {
			package = pkgs.firefox;
			src = pkgs.fetchurl {
				url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
				hash = "sha256-XRtG0iLKh8uqbeX7Rc2H6VJwZYJoNZPBlAfZEfrSCP4=";
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
					steam-database
					terms-of-service-didnt-read
					unpaywall
					wayback-machine
          tabcenter-reborn
				]
				++ (with customPkgs.mozilla.firefoxAddons; [
					librejs
				]);
				settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          
					# Arkenfox overrides
					"browser.startup.page" = 3;
					"privacy.clearOnShutdown.history" = false;
					"webgl.disabled" = false;
          "privacy.resistFingerprinting" = false;
          "privacy.resistFingerprinting.letterboxing" = false;
				};
		  };
		};
	};

	home.persistence.${persistDirectory} = {
    directories = [ ".mozilla" ];
  };
}
