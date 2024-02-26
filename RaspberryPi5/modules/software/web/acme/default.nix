{ ... }: {
  security.acme = {
    defaults = {
      email = "tilldusan30+acme@gmail.com";
    };
    certs."duanin2.top" = {
      webroot = "/var/lib/acme/.challenges";
      group = "nginx";
      domain = "*.duanin2.top";
      dnsProvider = "cloudflare";
      environmentFile = "/var/lib/secrets/certs.secret";
    };
    acceptTerms = true;
  };
}