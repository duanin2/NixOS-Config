{ config, lib, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, pkgs, ... }: with lib; let
  cfg = config.services.rss-bridge;

  curl = pkgs.curl-impersonate-ff;

  host = "rssbridge.duanin2.top";
in {
  services.rss-bridge = {
    enable = true;

    virtualHost = host;

    config = {
      system = {
        enabled_bridges = ["*"];
        timezone = "Europe/Prague";
      };
      admin.email = "admin@${host}";
      error.output = "http";
    };
  };

  services.nginx.virtualHosts.${host} = {
    useACMEHost = "duanin2.top";
    addSSL = true;
    quic = true;
    
    extraConfig = (securitySetupNGINX [ host ]) + securityHeaders + httpsUpgrade + ocspStapling + ''
proxy_cache off;
    '' + quic;
  };

  services.phpfpm.pools.${cfg.pool} = {
    phpPackage = with pkgs; php.override {
      inherit curl;
    };
    phpOptions = ''
extension=${with pkgs; phpExtensions.curl.override {
  inherit curl;
}}/lib/php/extensions/curl.so
    '';
  };

  systemd.services."phpfpm-${cfg.pool}" = {
    environment = {
      "LD_PRELOAD" = "${curl}/lib/libcurl-impersonate.so";
      "CURL_IMPERSONATE" = "ff117";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      cfg.dataDir
    ];
  };
}