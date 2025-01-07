{ clientConfig }: { pkgs, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, ... }: let
  host = "element.duanin2.top";
in {
  services.nginx.virtualHosts = {
    ${host} = {
      useACMEHost = "duanin2.top";
      onlySSL = true;
      
      root = pkgs.element-web.override {
        conf = {
          default_server_config = clientConfig; # see `clientConfig` from the snippet above.
        };
      };

      extraConfig = (securitySetupNGINX [ host ]) + ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
      '' + httpsUpgrade + ocspStapling;
    };
  };
}
