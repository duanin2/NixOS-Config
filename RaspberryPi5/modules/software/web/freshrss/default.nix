{ pkgs, config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, modules, ... }: let
  host = "freshrss.duanin2.eu";
in {
  imports = [
    (modules.local.software + /postgres)
  ];

  services.freshrss = {
    enable = true;

    virtualHost = host;
    language = "cs";

    extensions = with pkgs.freshrss-extensions; [
      youtube
      title-wrap
      reading-time
    ];

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
    useACMEHost = "duanin2.eu";
    addSSL = true;
    quic = true;

    serverAliases = [ "freshrss.duanin2.top" ];
    
    extraConfig = (securitySetupNGINX [ host "freshrss.duanin2.top" ]) + ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
  '' + httpsUpgrade + ocspStapling + quic;
  };

  environment.persistence."/persist" = let
    cfg = config.services.freshrss;
  in {
    directories = [
      cfg.dataDir
    ];
  };
}