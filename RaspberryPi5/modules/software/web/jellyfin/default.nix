{ pkgs, config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
  host = "jellyfin.duanin2.top";
in {
  services.jellyfin = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    1900
    7359
  ];

  services.nginx.virtualHosts.${host} = {
    useACMEHost = "duanin2.top";
    onlySSL = true;
    
    locations."/" = {
      proxyPass = "http://localhost:8096";
			proxyWebsockets = true;
    };

    extraConfig = (securitySetupNGINX [ host ]) + ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
    '' + httpsUpgrade + ocspStapling;
  };

  environment.persistence."/persist" = let
    cfg = config.services.jellyfin;
  in {
    directories = [
      cfg.dataDir
      cfg.configDir
      cfg.logDir
    ];
  };
}
