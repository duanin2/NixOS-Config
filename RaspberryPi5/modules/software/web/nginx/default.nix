{ ... }: {
  imports = [
    ../acme
  ];

  services.nginx = {
    enable = true;

    virtualHosts = {
      "acmechallenge.duanin2.top" = {
        # Catchall vhost, will redirect users to HTTPS for all vhosts
        serverAliases = [ "*.duanin2.top" ];
        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/.challenges";
        };
        locations."/" = {
          return = "301 https://$host$request_uri";
        };
      };
    };

    streamConfig = ''
    upstream asus_aicloud {
      server 192.168.1.1:443;
    }

    server {
      listen bohousek10d1979.asuscomm.com:443;
      ssl_preread on;
      proxy_pass asus_aicloud;
    }
    '';
  };

  users.users.nginx.extraGroups = [ "acme" ];
}