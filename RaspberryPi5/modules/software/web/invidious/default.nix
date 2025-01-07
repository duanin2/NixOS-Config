{ config, lib, pkgs, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
  host = "invidious.duanin2.top";
in {
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

    domain = host;
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

  services.nginx.virtualHosts.${host} = {
    enableACME = lib.mkForce false;
    useACMEHost = "duanin2.top";
    forceSSL = lib.mkForce false;
    onlySSL = true;

    extraConfig = (securitySetupNGINX [ host ]) + ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

proxy_cache_key "$proxy_host$proxy_port$request_uri$args$cookie_sid";
proxy_cache_valid any 10m;
    '' + httpsUpgrade + ocspStapling;
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/private/invidious"
    ];
  };
}
