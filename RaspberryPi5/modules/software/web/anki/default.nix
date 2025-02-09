{ config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, ... }: let
  address = "127.0.0.1";
  port = 8123;

  host = "anki.duanin2.top";
in {
  services.anki-sync-server = {
    inherit address port;

    enable = true;

    users = [
      rec { username = "duanin2"; passwordFile = "/var/lib/secrets/ankiPass/${username}"; }
    ];
  };

  services.nginx.virtualHosts.${host} = {
    useACMEHost = "duanin2.top";
    onlySSL = true;
    quic = true;
    
    locations."/" = {
      proxyPass = "http://${address}:${toString port}";
			proxyWebsockets = true;
    };

    extraConfig = (securitySetupNGINX [ host ]) + securityHeaders + httpsUpgrade + ocspStapling + quic;
  };
}