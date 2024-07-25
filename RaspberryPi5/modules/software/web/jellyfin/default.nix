{ pkgs, config, ... }: {
  services.jellyfin = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    1900
    7359
  ];

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
