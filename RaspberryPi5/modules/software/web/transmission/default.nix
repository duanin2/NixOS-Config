{ pkgs, config, ... }: let
  cfg = config.services.transmission;
in {
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;

    webHome = pkgs.flood-for-transmission;
    openPeerPorts = true;
    home = "/torrent";
    credentialsFile = "/var/lib/secrets/transmission/settings.json";
  };

  services.nginx.virtualHosts."transmission.duanin2.top" = {
    useACMEHost = "duanin2.top";

    listen = [
      { addr = "0.0.0.0"; port = 80; }
    ];

    locations."/".proxyPass = "http://${cfg.settings.rpc-bind-address}:${builtins.toString cfg.settings.rpc-port}";
  };
}