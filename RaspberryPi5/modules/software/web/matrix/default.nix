{ pkgs, lib, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
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

  secretsFile = "/var/lib/secrets/matrix-secrets.yaml";
in {
  imports = [
    (import ./element.nix { inherit clientConfig; })
  ];
  
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
      email = {
        smtp_host = "duanin2.top";
        smtp_user = "matrix-noreply@duanin2.top";
        force_tls = true;
        notif_from = "Your %(app)s homeserver <matrix-noreply@duanin2.top>";
        enable_notifs = true;
        notif_for_new_users = false;
        notif_delay_before_mail = "1h";
      };

      database = {
        args = {
          user = "synapse_user";
          dbname = "synapse";
          host = "localhost";
          cp_min = 5;
          cp_max = 10;
        };
      };

      admin_contact = "mailto:admin-matrix@duanin2.top";
    };
    extraConfigFiles = [ secretsFile ];
  };

  services.nginx.virtualHosts = {
    "duanin2.top".locations = {
      "/.well-known/matrix/server" = {
        extraConfig = (mkWellKnown { "m.server" = "matrix.${domain}:443"; }) + securityHeaders;
        priority = 0;
      };
      "/.well-known/matrix/client" = {
        extraConfig = (mkWellKnown clientConfig) + securityHeaders;
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

      extraConfig = (securitySetupNGINX [ "matrix.duanin2.top" ]) + securityHeaders + httpsUpgrade + ocspStapling;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/private/matrix-synapse"
    ];
  };

  # Automatic config fixes
  /*
  system.activationScripts = {
    synapse-config-fix.text = ''
cat <<EOF > ${secretsFile}
${lib.generators.toYAML (builtins.mapAttrs (name: value: ) ((builtins.readFile secretsFile)))}
EOF
    '';
  };
  */
}
