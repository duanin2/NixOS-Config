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
        listen = [
          # Nevím
        ];
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}