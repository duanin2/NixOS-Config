{ config, lib, ... }: {
  services.invidious = {
    enable = true;

    domain = "invidious.duanin2.top";
    nginx.enable = true;

    settings.db.user = "invidious";
  };

  services.nginx.virtualHosts.${config.services.invidious.domain} = {
    enableACME = lib.mkForce false;
    useACMEHost = "duanin2.top";
  };
}
