{ config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: {
  services.ntfy-sh = {
    enable = true;

    user = "ntfy";
    group = "ntfy";

    settings = {
      base-url = "https://ntfy.duanin2.top";
      listen-http = "127.0.0.1:1280";
      behind-proxy = true;
      # smtp-sender-addr = "duanin2.top:465";
      # smtp-sender-from = "ntfy@duanin2.top";
      upstream-base-url = "https://ntfy.sh";
      visitor-request-limit-exempt-hosts = "duanin2.top,192.168.1.0/24,127.0.0.0/8";
   };
  };
  
  services.nginx.virtualHosts = {
    "ntfy.duanin2.top" = {
      useACMEHost = "duanin2.top";
      onlySSL = true;

      location."/" = {
        proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
      };

      extraConfig = (securitySetupNGINX [ "ntfy.duanin2.top" ]) + securityHeaders + httpsUpgrade + ocspStapling;
    };
  };
}
