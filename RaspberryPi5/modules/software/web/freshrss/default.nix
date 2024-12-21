{ config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
  host = "freshrss.duanin2.top";
in {
  services.freshrss = {
    enable = true;

    virtualHost = host;
    language = "cs";

    defaultUser = "admin";
    passwordFile = "/var/lib/secrets/freshrss/adminPass";

    baseUrl = "https://${host}";

    database = {
      type = "pgsql";

      user = "freshrss";
      name = "freshrss";
      passFile = "/var/lib/secrets/freshrss/dbPass";
    };
  };

  services.nginx.virtualHosts.${host} = {
    useACMEHost = "duanin2.top";
    addSSL = true;
    
    extraConfig = (securitySetupNGINX [ host ]) + securityHeaders + httpsUpgrade + ocspStapling;
  };

  environment.persistence."/persist" = let
    cfg = config.services.freshrss;
  in {
    directories = [
      cfg.dataDir
    ];
  };
}