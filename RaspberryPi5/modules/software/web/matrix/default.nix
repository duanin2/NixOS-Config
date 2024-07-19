{ ... }: let
  domain = "matrix.duanin.top";
  baseUrl = "https://${domain}";
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
    };
    extraConfigFiles = [ "/var/lib/secrets/matrix-secrets.yaml" ];
  };

  services.nginx.virtualHosts = {
    "duanin2.top".locations = {
      "/.well-known/matrix/server" = {
        extraConfig = mkWellKnown { "m.homeserver".base_url = baseUrl; };
        priority = 0;
      };
       "/.well-known/matrix/client" = {
        extraConfig = mkWellKnown { "m.server".base_url = "${domain}:443"; };
        priority = 0;
      };
    };
    "${domain}" = {
      useACMEHost = "duanin2.top";
      onlySSL = true;
      locations = {
        "/_matrix" = {
          proxyPass = "http://localhost:${toString port}/_matrix";
          extraConfig = ''
proxy_http_version 1.1;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_set_header X-Forwarded-Proto $scheme;
          '';
          priority = 0;
        };
        "/_synapse/client" = {
          proxyPass = "http://localhost:${toString port}/_synapse/client";
          extraConfig = ''
proxy_http_version 1.1;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_set_header X-Forwarded-Proto $scheme;
          '';
          priority = 0;
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
