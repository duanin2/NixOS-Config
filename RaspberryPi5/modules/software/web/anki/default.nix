{ config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
  address = "127.0.0.1";
  port = 8123;
in {
  services.anki-sync-server = {
    inherit address port;

    enable = true;

    users = [
      rec { username = "duanin2"; passwordFile = "/var/lib/secrets/ankiPass/${username}"; }
    ];
  };

  services.nginx.virtualHosts."matrix.duanin2.top" = {
    useACMEHost = "duanin2.top";
    onlySSL = true;
    
    locations."/" = {
      proxyPass = "http://${address}:${port}";
			proxyWebsockets = true;
    };

    extraConfig = (securitySetupNGINX [ "matrix.duanin2.top" ]) + securityHeaders + httpsUpgrade + ocspStapling;
  };
}