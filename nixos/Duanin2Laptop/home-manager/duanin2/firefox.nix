{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox_nightly;

    profiles = {
      "default" = {
        id = 0;
        isDefault = true;

        search = {
          force = true;
          default = "SearXNG";

          engines = {
            "SearXNG" = {
              urls = [
                {
                  template = "https://searx.be/search";
                  params = [{
                    name = "query";
                    value = "{searchTerms}";
                  }];
                }
              ];
              iconUpdateURL = "https://searx.be/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # daily
              definedAliases = [ "@sx" ];
            };
          };
          order = [ "SearXNG" ];
        };
        settings = {
          "browser.download.animateNotifications" = false; # Disable notification animations
          "security.dialog_enable_delay" = 0;

          # Telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-center.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Disable built-in add-ons
          "reader.parse-on-load.enabled" = false;
          "reader.parse-on-load.force-enabled" = false;
          "browser.pocket.enabled" = false;
          "loop.enabled" = false;
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          auto-tab-discard

          keepassxc-browser
          libredirect
          localcdn
          stylus
          tampermonkey
          terms-of-service-didnt-read
          ublock-origin
        ];
      };
    };
  };
}
