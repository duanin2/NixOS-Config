{ config, securitySetupNGINX, ... }: {
  services.searx = {
    enable = true;

    redisCreateLocally = true;
    limiterSettings = {
      real_ip = {
        x_for = 1;

        ipv4_prefix = 32;
        ipv6_prefix = 56;
      };

      botdetection = {
        ip_limit = {
          filter_link_local = true;
          link_token = true;
        };
        ip_lists = {
          pass_ip = [
            "192.168.0.0/16"
            "fe80::/10"
          ];
          pass_searxng_org = true;
        };
      };
    };
    settings = {
      general = {
        donation_url = false;
        enable_metrics = false;
      };
      search = {
        safe_search = 1;
        default_lang = "cs";
        ban_time_on_fail = 60;
        max_ban_time_on_fail = 3600;
      };
      server = {
        base_url = "https://searx.duanin2.top/";
        port = 9393;
        bind_address = "127.0.0.1";
        image_proxy = true;
      };
      ui = {
        default_locale = "cs";
        query_in_title = false;
        infinite_scroll = true;
        results_on_new_tab = true;
        search_on_category_select = false;
      };
      outgoing = {
        request_timeout = 2.0;
        max_request_timeout = 5.0;
        useragent_suffix = "duanin2@gmail.com";
        max_redirects = 10;
      };
    };
    environmentFile = "/var/lib/secrets/searx.env";
  };

  services.nginx.virtualHosts."searx.duanin2.top" = {
    useACMEHost = "duanin2.top";
    onlySSL = true;
    
    locations."/" = {
      proxyPass = "http://${config.services.searx.settings.server.bind_address}:${builtins.toString config.services.searx.settings.server.port}";
    };

    extraConfig = securitySetupNGINX "searx.duanin2.top";
  };
}
