{ nur, customPkgs, pkgs, persistDirectory, ... }: {
  disabledModules = [ ./mullvad.nix ];

  home.packages = with pkgs; [
    # firefoxpwa
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    languagePacks = [
      "en-GB"
      "cs"
    ];
    nativeMessagingHosts = with pkgs; [
      # firefoxpwa
      kdePackages.plasma-browser-integration
    ];
    policies = {
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      HttpsOnlyMode = "force_enabled";
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      SearchBar = "unified";
      NewTabPage = false;
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
        extensions.packages = with nur.repos.rycee.firefox-addons; [
          sponsorblock
          dearrow
          enhanced-h264ify
          annotations-restored
          return-youtube-dislikes
          blocktube

          steam-database
          protondb-for-steam

          violentmonkey
          stylus
          sidebery
          # firefox-color

          ublock-origin
          canvasblocker
          redirector
          # foxyproxy-standard

          terms-of-service-didnt-read
          rsspreview

          aria2-integration
          plasma-integration
        ]
        ++ (with customPkgs.mozilla.firefoxAddons; [
          # librejs
          # firefoxpwa
        ]);
        settings = (customPkgs.mozilla.addUserJsPrefs (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
          hash = "sha256-XRtG0iLKh8uqbeX7Rc2H6VJwZYJoNZPBlAfZEfrSCP4=";
        })).res // {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "javascript.enabled" = true;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "image.jxl.enabled" = true;

          # Arkenfox overrides
          "browser.startup.page" = 3;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.sessions" = false;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
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
    };
  };

  home.persistence.${persistDirectory} = {
    directories = [ ".mozilla" ];
  };
}
