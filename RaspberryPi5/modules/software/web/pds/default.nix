{ config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, modules, ... }: let
  host = "pds.duanin2.eu";

  cfg = config.services.pds;
in {
  services.pds = {
    enable = true;

    environmentFiles = [ "/var/lib/secrets/atproto-pds" ];
    settings = {
      PDS_HOSTNAME = host;
    };
  };

  services.nginx.virtualHosts.${host} = {
    useACMEHost = "duanin2.eu";
    addSSL = true;
    quic = true;

    locations."/" = {
      proxyPass = "http://localhost:${toString cfg.settings.PDS_PORT}";
      proxyWebsockets = true;
    };
    
    extraConfig = (securitySetupNGINX [ host ]) + ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
    '' + httpsUpgrade + ocspStapling + quic;
  };

  environment.persistence."/persist" = {
    directories = [
      cfg.settings.PDS_DATA_DIRECTORY
    ];
  };
}