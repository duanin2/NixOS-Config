{ pkgs, config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: {
  services.jellyfin = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    1900
    7359
  ];

  services.nginx.virtualHosts."jellyfin.duanin2.top" = {
    useACMEHost = "duanin2.top";
    onlySSL = true;
    
    locations."/" = {
      proxyPass = "http://localhost:8096";
    };

    extraConfig = (securitySetupNGINX [ "jellyfin.duanin2.top" ]) + securityHeaders + httpsUpgrade + ocspStapling;
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
