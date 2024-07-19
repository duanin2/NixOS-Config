{ pkgs, lib, ... }: let
  domain = "duanin2.top";
  baseUrl = "https://matrix.${domain}";
  clientConfig."m.homeserver".base_url = baseUrl;
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';

  port = 8008;
  address = "127.0.0.1";
in {
  services.matrix-synapse = {
    enable = true;
    enableRegistrationScript = true;

    settings = {
      server_name = domain;
      public_baseurl = baseUrl;
      listeners = [
        {
          inherit port;
          bind_addresses = [ address ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = true;
            }
          ];
        }
      ];

      enable_registration = true;
      enable_metrics = true;
      url_preview_ip_range_blacklist = lib.mkForce [
        "192.168.1.0/24"
        "127.0.0.0/8"
        "::1/128"
        "fe80::/64"
      ];
      url_preview_enabled = true;
      enable_registration_captcha = true;
    };
    extraConfigFiles = [ "/var/lib/secrets/matrix-secrets.yaml" ];
  };

  services.nginx.virtualHosts = {
    "duanin2.top".locations = {
      "/.well-known/matrix/server" = {
        extraConfig = mkWellKnown clientConfig;
        priority = 0;
      };
       "/.well-known/matrix/client" = {
        extraConfig = mkWellKnown { "m.server".base_url = "${domain}:443"; };
        priority = 0;
      };
    };
    "matrix.${domain}" = {
      useACMEHost = "duanin2.top";
      onlySSL = true;
      locations = {
        "/".return = "301 https://element.duanin2.top";
        "/_matrix" = {
          proxyPass = "http://${address}:${toString port}";
          priority = 0;
        };
        "/_synapse/client" = {
          proxyPass = "http://${address}:${toString port}";
          priority = 0;
        };
      };
    };
    "element.duanin2.top" = {
      useACMEHost = "duanin2.top";
      onlySSL = true;
      root = pkgs.element-web.override {
        conf = {
          default_server_config = clientConfig; # see `clientConfig` from the snippet above.
        };
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/private/matrix-synapse"
    ];
  };
}
