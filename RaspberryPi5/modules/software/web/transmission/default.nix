{ pkgs, ... }: {
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;

    webHome = pkgs.flood-for-transmission;
    openPeerPort = true;
    home = "/torrent";
    credentialsFile = "/var/lib/secrets/transmission/settings.json";
  };

  services.nginx.virtualHosts."transmission.duanin2.top" = {
    useACMEHost = "duanin2.top";

    
  };
}