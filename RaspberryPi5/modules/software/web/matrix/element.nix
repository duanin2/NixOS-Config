{ clientConfig }: { pkgs, securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, ... }: let
  host = "element.duanin2.eu";
in {
  services.nginx.virtualHosts = {
    ${host} = {
      useACMEHost = "duanin2.eu";
      onlySSL = true;
      quic = true;

      serverAliases = [ "element.duanin2.top" ];
      
      root = pkgs.element-web.override {
        conf = {
          default_server_config = clientConfig; # see `clientConfig` from the snippet above.
        };
      };

      extraConfig = (securitySetupNGINX [ host "element.duanin2.top" ]) + ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer" always;
      '' + httpsUpgrade + ocspStapling + quic;
    };
  };
}
