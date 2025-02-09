{ inputs, pkgs, lib, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, modules, ... }: let
  domain = "duanin2.top";
  host = "matrix.${domain}";
  baseUrl = "https://${host}";
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
    (modules.local.software + /postgres)
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
        smtp_user = "noreply@${host}";
        force_tls = true;
        notif_from = "Your %(app)s homeserver <noreply@${host}>";
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

      enable_authenticated_media = true;
      enable_media_repo = true;
      max_pending_media_uploads = 10;
      unused_expiration_time = "12h";
      max_upload_size = "50M";
      max_image_pixels = "50M";
      dynamic_thumbnails = true;

      admin_contact = "mailto:admin@${host}";
    };
    extraConfigFiles = [ secretsFile ];
  };

  services.nginx.virtualHosts = {
    ${domain}.locations = {
      "/.well-known/matrix/server" = {
        extraConfig = (mkWellKnown { "m.server" = "${host}:443"; }) + securityHeaders + quic + ''
add_header Cache-Control "public, max-age=${toString (24 * 60 * 60)}, no-transform, no-cache, must-revalidate";
        '';
        priority = 0;
      };
      "/.well-known/matrix/client" = {
        extraConfig = (mkWellKnown clientConfig) + securityHeaders + quic + ''
add_header Cache-Control "public, max-age=${toString (24 * 60 * 60)}, no-transform, no-cache, must-revalidate";
        '';
        priority = 0;
      };
    };
    ${host} = {
      useACMEHost = "duanin2.top";
      onlySSL = true;
      quic = true;
      
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

      extraConfig = (securitySetupNGINX [ host ]) + securityHeaders + httpsUpgrade + ocspStapling + ''
client_max_body_size 50M;
      ''  + quic;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/matrix-synapse"
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
