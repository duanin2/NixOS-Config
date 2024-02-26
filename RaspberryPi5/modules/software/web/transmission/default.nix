{ pkgs, config, ... }: {
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
      {
        addr = "127.0.0.1";
        port = config.services.transmission.rpc-port;
      }
    ];
  };
}