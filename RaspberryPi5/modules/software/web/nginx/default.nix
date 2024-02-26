{ ... }: {
  imports = [
    ../acme
  ];

  services.nginx = {
    enable = true;

    enableQuicBPF = true;
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
  };

  users.users.nginx.extraGroups = [ "acme" ];
}