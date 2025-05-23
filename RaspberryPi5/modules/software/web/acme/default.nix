{ securitySetupNGINX, securityHeaders, httpsUpgrade, ocspStapling, quic, ... }: {
  security.acme = {
    defaults = {
      # webroot = "/var/lib/acme/.challenges";
      email = "tilldusan30+acme@gmail.com";
    };
    certs."duanin2.eu" = {
      group = "nginx";
      domain = "duanin2.eu";
      extraDomainNames = [ "*.duanin2.eu" "duanin2.top" "*.duanin2.top" ];
      dnsProvider = "cloudflare";
      environmentFile = "/var/lib/secrets/certs.secret";
      extraLegoRunFlags = [ /*"--must-staple"*/ ];
      extraLegoRenewFlags = [ "--reuse-key" /*"--must-staple"*/ ];
    };
    /*
    certs."asuscomm.com" = {
      group = "nginx";
      domain = "bohousek10d1979.asuscomm.com";
      environmentFile = "/var/lib/secrets/certs.secret";
    };
    */
    acceptTerms = true;
  };

  services.nginx.virtualHosts."acmechallenge.duanin2.eu" = {
    default = true;
    useACMEHost = "duanin2.eu";
    addSSL = true;
    quic = true;
    
    locations."/.well-known/acme-challenge" = {
      root = "/var/lib/acme/.challenges";
      priority = 0;
    };

    extraConfig = (securitySetupNGINX [ "acmechallenge.duanin2.eu" ]) + (let
          allowedSrc = "'self' $scheme://duanin2.eu $scheme://*.duanin2.eu $scheme://duanin2.top $scheme://*.duanin2.top";
        in ''
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Content-Security-Policy "default-src ${allowedSrc}; base-uri ${allowedSrc}; frame-src ${allowedSrc}; frame-ancestors ${allowedSrc}; form-action ${allowedSrc}" always;
add_header Referrer-Policy "no-referrer" always;
add_header Cache-Control "no-store";
        '') + httpsUpgrade + ocspStapling + ''
proxy_cache off;
    '' + quic;
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib/acme" ];
  };
}
