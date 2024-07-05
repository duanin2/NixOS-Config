{ config, lib, pkgs, ... }: {
  services.invidious = {
    enable = true;
    package = pkgs.invidious.override {
      versions = {
        invidious = {
          hash = "";
          version = "v2.2024.05.27-unstable";
          rev = "1ae14cc22468ce6e0eb794752b113604b1d5582d";
          date = "2024.05.27";
          commit = "1ae14cc";
        };
        videojs = {
          hash = "sha256-jED3zsDkPN8i6GhBBJwnsHujbuwlHdsVpVqa1/pzSH4=";
        };
      };
    };

    http3-ytproxy = {
      enable = true;
    };

    domain = "invidious.duanin2.top";
    nginx.enable = true;

    settings.db.user = "invidious";
  };

  services.nginx.virtualHosts.${config.services.invidious.domain} = {
    enableACME = lib.mkForce false;
    useACMEHost = "duanin2.top";
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/private/invidious"
    ];
  };
}
