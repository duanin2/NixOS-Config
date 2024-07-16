{ lib, config, nur, customPkgs, pkgs, inputs, persistDirectory, ... }: {
  disabledModules = [ ./mullvad.nix ];
  
	programs.firefox = with pkgs; {
		enable = true;
    package = customPkgs.mozilla.addUserJsPrefs {
			package = firefox;
			src = fetchurl {
				url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
				hash = "sha256-XRtG0iLKh8uqbeX7Rc2H6VJwZYJoNZPBlAfZEfrSCP4=";
			};
		};

		profiles = {
		  "default" = {
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
					steam-database
					terms-of-service-didnt-read
					unpaywall
					wayback-machine
          sidebery
          aria2-integration
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
        userChrome = ''
/* Hide the TabBar */
#TabsToolbar {
  visibility: collapse !important;
}

/* Hide the Sidebar header */
#sidebar-header, .sidebar-splitter {
  visibility: collapse !important;
}
        '';
		  };
		};
	};

	home.persistence.${persistDirectory} = {
    directories = [ ".mozilla" ];
  };
}
