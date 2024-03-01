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
      "bohousek10d1979.asuscomm.com" = {
        enableACME = false;
        useACMEHost = "duanin2.top";
        listen = [
          { addr = "0.0.0.0"; port = 80; }
          { addr = "0.0.0.0"; port = 443; ssl = true; }
        ];

        locations."/".proxyPass = "https://192.168.1.1";
        default = true;
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}