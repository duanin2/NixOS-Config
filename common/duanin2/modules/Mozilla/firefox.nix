{ lib, config, nur, customPkgs, pkgs, inputs, persistDirectory, ... }: {
  disabledModules = [ ./mullvad.nix ];
  
	programs.firefox = with pkgs; {
		enable = true;
    package = customPkgs.mozilla.addUserJsPrefs {
			package = (firefox.override (old: {
        nativeMessagingHosts = (old.nativeMessagingHosts or []) ++ (with pkgs; [
          firefoxpwa
        ]);
      }));
			src = fetchurl {
				url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
				hash = "sha256-Blf/dEQFcHYZg6ElwNB6+RSJ0UlnfvqVMTmI69OI50k=";
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
          firefoxpwa
				]);
				settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "javascript.enabled" = true;
          
					# Arkenfox overrides
          "browser.startup.page" = 3;
          "privacy.clearOnShutdown.history" = false;
					"webgl.disabled" = false;
          "privacy.resistFingerprinting" = false;
          "privacy.resistFingerprinting.letterboxing" = false;
          "javascript.options.wasm" = true;
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
