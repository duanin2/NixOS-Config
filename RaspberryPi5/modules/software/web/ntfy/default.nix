{ config, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, ... }: let
  host = "ntfy.duanin2.eu";
in {
  services.ntfy-sh = {
    enable = true;

    user = "ntfy";
    group = "ntfy";

    settings = {
      base-url = "https://${host}";
      upstream-base-url = "https://ntfy.sh";
      
      listen-http = "127.0.0.1:1280";
      behind-proxy = true;
      visitor-request-limit-exempt-hosts = "duanin2.eu,duanin2.top,192.168.1.0/24,127.0.0.0/8";

      #smtp-sender-addr = "duanin2.eu:465";
      #smtp-sender-from = "ntfy@ntfy.duanin2.eu";

      auth-file = "/var/lib/ntfy-sh/user.db";
      auth-default-access = "deny-all";
    };
  };
  
  services.nginx.virtualHosts.${host} = {
    useACMEHost = "duanin2.eu";
    onlySSL = true;
    quic = true;

    serverAliases = [ "ntfy.duanin2.top" ];

    locations."/" = {
      proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
      proxyWebsockets = true;
    };

    extraConfig = (securitySetupNGINX [ host "ntfy.duanin2.top" ]) + ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
    '' + httpsUpgrade + ocspStapling + quic;
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/private/ntfy-sh"
    ];
  };
}
