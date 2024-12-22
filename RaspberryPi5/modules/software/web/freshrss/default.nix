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
    
    extraConfig = (securitySetupNGINX [ host ]) + ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
  '' + httpsUpgrade + ocspStapling;
  };

  environment.persistence."/persist" = let
    cfg = config.services.freshrss;
  in {
    directories = [
      cfg.dataDir
    ];
  };
}