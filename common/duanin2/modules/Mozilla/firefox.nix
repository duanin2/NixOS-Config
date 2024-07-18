{ lib, config, nur, customPkgs, pkgs, inputs, persistDirectory, ... }: {
  disabledModules = [ ./mullvad.nix ];

  home.packages = with pkgs; [
    firefoxpwa
  ];
  
	programs.firefox = {
		enable = true;
    package = pkgs.firefox;

    nativeMessagingHosts = with pkgs; [
      firefoxpwa
    ];
    policies = [
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      HttpsOnlyMode = "force_enabled";
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      SearchBar = "unified";
      NewTabPage = false;
    ];
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
				settings = customPkgs.mozilla.addUserJsPrefs (fetchurl {
			    url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
			    hash = "sha256-Blf/dEQFcHYZg6ElwNB6+RSJ0UlnfvqVMTmI69OI50k=";
		    }) // {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "javascript.enabled" = true;
          
					# Arkenfox overrides
          "browser.startup.page" = 3;
          "privacy.clearOnShutdown.history" = false;
					"webgl.disabled" = false;
          "privacy.resistFingerprinting" = false;
          "privacy.resistFingerprinting.letterboxing" = false;
          "javascript.options.asmjs" = true;
          "javascript.options.baselinejit" = true;
          "javascript.options.ion" = true;
          "javascript.options.wasm" = true;
          "browser.tabs.inTitlebar" = 0;
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
      "firefoxpwa-template" = {
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
				  stylus
				  canvasblocker
				  firemonkey
				  terms-of-service-didnt-read
				  wayback-machine
          aria2-integration
			  ]
			  ++ (with customPkgs.mozilla.firefoxAddons; [
				  librejs
			  ]);
			  settings = customPkgs.mozilla.addUserJsPrefs (fetchurl {
			    url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
			    hash = "sha256-Blf/dEQFcHYZg6ElwNB6+RSJ0UlnfvqVMTmI69OI50k=";
		    }) // {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "javascript.enabled" = true;
          
					# Arkenfox overrides
          "browser.startup.page" = 3;
          "privacy.clearOnShutdown.history" = false;
					"webgl.disabled" = false;
          "privacy.resistFingerprinting" = false;
          "privacy.resistFingerprinting.letterboxing" = false;
          "javascript.options.asmjs" = true;
          "javascript.options.baselinejit" = true;
          "javascript.options.ion" = true;
          "javascript.options.wasm" = true;
          "browser.tabs.inTitlebar" = 0;
				};
		  };
	  };
  };

  home.persistence.${persistDirectory} = {
    directories = [ ".mozilla" ];
  };
}
