{ config, lib, pkgs, securitySetupNGINX, securityHeaders, httpsUpgrade, ... }: {
  services.invidious = {
    enable = true;
    package = pkgs.invidious.override {
      versions = {
        invidious = {
          hash = "";
          version = "v2.2024.07.21-unstable";
          rev = "325561e7553601e0f81ba72ca33ffe52079f3b2a";
          date = "2024.07.21";
          commit = "325561e";
        };
        videojs = {
          hash = "sha256-jED3zsDkPN8i6GhBBJwnsHujbuwlHdsVpVqa1/pzSH4=";
        };
      };
    };

    http3-ytproxy = {
      enable = true;
    };

    domain = "invidious.duanin2.top";
    nginx.enable = true;

    settings.db.user = "invidious";

    settings = {
      popular_enabled = false;
      statistics_enabled = true;
      admins = [ "duanin2" ];
      use_pubsub_feeds = true;
      cache_annotations = true;
      playlist_length_limit = 1000;

      default_user_preferences = {
        locale = "cs";
        region = "CZ";
        captions = [ "Czech" "English" "English (auto-generated)" ];
        feed_menu = [ "Trending" "Subscriptions" "Playlists" ];
        defaut_home = "Subsciptions";
        max_results = 50;
        annotations = true;
        annotations_subscribed = true;
        comments = [ "youtube" "reddit" ];
        player_style = "youtube";
        quality = "dash";
        save_player_pos = true;
        automatic_instance_redirect = true;
      };
    };
  };

  services.nginx.virtualHosts.${config.services.invidious.domain} = {
    enableACME = lib.mkForce false;
    useACMEHost = "duanin2.top";
    forceSSL = lib.mkForce false;
    onlySSL = true;

    extraConfig = (securitySetupNGINX "invidious.duanin2.top") + securityHeaders + httpsUpgrade;
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/private/invidious"
    ];
  };
}
