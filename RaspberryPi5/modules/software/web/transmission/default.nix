{ pkgs, config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, ... }: let
  cfg = config.services.transmission;

  host = "transmission.duanin2.eu";
in {
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;

    webHome = pkgs.flood-for-transmission;
    openPeerPorts = true;
    home = "/torrent";
    credentialsFile = "/var/lib/secrets/transmission/settings.json";
    settings = {
      speed-limit-up = "1500";
      speed-limit-up-enabled = true;
      speed-limit-down = "1500";
      speed-limit-down-enabled = true;

      encryption = 2;
      lpd-enabled = true;
    };
  };

  services.nginx.virtualHosts.${host} = {
    useACMEHost = "duanin2.eu";
    onlySSL = true;
    quic = true;

    serverAliases = [ "transmission.duanin2.top" ];

    locations."/".proxyPass = "http://${cfg.settings.rpc-bind-address}:${builtins.toString cfg.settings.rpc-port}";

    extraConfig = (securitySetupNGINX [ host "transmission.duanin2.top" ]) + securityHeaders + httpsUpgrade + ocspStapling + quic;
  };
}