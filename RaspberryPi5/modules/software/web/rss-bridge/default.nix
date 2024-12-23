{ config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
  host = "rssbridge.duanin2.top";
in {
  services.rss-bridge = {
    enable = true;

    virtualHost = host;

    user = "rssbridge";
    group = "rssbridge";

    config = {
      system = {
        enabled_bridges = ["*"];
        timezone = "Europe/Prague";
      };
      admin.email = "admin@${host}";
      error.output = "http";
    };
  };

  services.nginx.virtualHosts.${host} = {
    useACMEHost = "duanin2.top";
    addSSL = true;
    
    extraConfig = (securitySetupNGINX [ host ]) + securityHeaders + httpsUpgrade + ocspStapling;
  };

  environment.persistence."/persist" = let
    cfg = config.services.rss-bridge;
  in {
    directories = [
      cfg.dataDir
    ];
  };
}