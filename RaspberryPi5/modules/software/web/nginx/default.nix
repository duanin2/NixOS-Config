{ ... }: {
  imports = [
    ../acme
  ];

  services.nginx = {
    enable = true;

    virtualHosts = {
      "acmechallenge.duanin2.top" = {
        # Catchall vhost, will redirect users to HTTPS for all vhosts
        serverAliases = [ "*.duanin2.top" "bohousek10d1979.asuscomm.com" ];
        
        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/.challenges";
          priority = 0;
        };
        locations."/" = {
          return = "301 https://$host$request_uri";
          priority = 1000;
        };
      };
      "duanin2.top" = {
        useACMEHost = "duanin2.top";
        forceSSL = true;
      };
      /*"bohousek10d1979.asuscomm.com" = {
        useACMEHost = "asuscomm.com";

        locations."/".proxyPass = "https://192.168.1.1";

        onlySSL = true;
      };*/
    };
  };

  users.users.nginx.extraGroups = [ "acme" "searx" ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
