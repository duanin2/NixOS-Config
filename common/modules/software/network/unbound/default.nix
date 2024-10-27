{ ... }: {
  services.unbound = {
    enable = true;

    enableRootTrustAnchor = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [
          "127.0.0.1"
          "127.0.0.53"
          "::1"
        ];
        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"

              "1.1.1.1@443#cloudflare-dns.com"
              "1.0.0.1@443#cloudflare-dns.com"
            ];
            forward-ssl-upstream = "yes";
          }
        ];
      };
    };
  };

  networking.resolvconf.enable = true;
  
  services.kresd.enable = lib.mkForce false;
}
