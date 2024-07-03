{ ... }: {
  security.acme = {
    defaults = {
      email = "tilldusan30+acme@gmail.com";
    };
    certs."duanin2.top" = {
      # webroot = "/var/lib/acme/.challenges";
      group = "nginx";
      domain = "duanin2.top";
      extraDomainNames = [ "*.duanin2.top" ];
      dnsProvider = "cloudflare";
      environmentFile = "/var/lib/secrets/certs.secret";
    };
    /*certs."asuscomm.com" = {
      webroot = "/var/lib/acme/.challenges";
      group = "nginx";
      domain = "bohousek10d1979.asuscomm.com";
      environmentFile = "/var/lib/secrets/certs.secret";
    };*/
    acceptTerms = true;
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib/acme" ];
  };
}
