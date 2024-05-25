{ config, ... }: {
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
    runInUwsgi = true;
    uwsgiConfig = {
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
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
        port = 443;
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
    
    locations."/" = {
      extraConfig = ''
uwsgi_pass unix:///run/searx/searx.sock;

uwsgi_param QUERY_STRING $query_string;
uwsgi_param REQUEST_METHOD $request_method;
uwsgi_param CONTENT_TYPE $content_type;
uwsgi_param CONTENT_LENGTH $content_length;
uwsgi_param REQUEST_URI $request_uri;
uwsgi_param PATH_INFO $document_uri;
uwsgi_param DOCUMENT_ROOT $document_root;
uwsgi_param SERVER_PROTOCOL $server_protocol;
uwsgi_param REMOTE_ADDR $remote_addr;
uwsgi_param REMOTE_PORT $remote_port;
uwsgi_param SERVER_ADDR $server_addr;
uwsgi_param SERVER_PORT $server_port;
uwsgi_param SERVER_NAME $server_name;

uwsgi_param    HTTP_HOST             $host;
uwsgi_param    HTTP_CONNECTION       $http_connection;

# flaskfix
uwsgi_param    HTTP_X_SCHEME         $scheme;
uwsgi_param    HTTP_X_SCRIPT_NAME    /searxng;

# limiter
uwsgi_param    HTTP_X_REAL_IP        $remote_addr;
uwsgi_param    HTTP_X_FORWARDED_FOR  $proxy_add_x_forwarded_for;
      '';
    };

    onlySSL = true;
  };
}
