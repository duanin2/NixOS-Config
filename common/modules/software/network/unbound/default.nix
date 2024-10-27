{ lib, ... }: {
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
        private-address = [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "169.254.0.0/16"
          "fd00::/8"
          "fe80::/10"
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
	    "2606:4700:4700::1111"
            "2606:4700:4700::1001"
            "1.1.1.1"
            "1.0.0.1"
          ];
        }
	{
	  name = ".";
	  forward-addr = [
            "2606:4700:4700::1111@853#cloudflare-dns.com"
            "2606:4700:4700::1001@853#cloudflare-dns.com"
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"

            "2606:4700:4700::1111@443#cloudflare-dns.com"
            "2606:4700:4700::1001@443#cloudflare-dns.com"
            "1.1.1.1@443#cloudflare-dns.com"
            "1.0.0.1@443#cloudflare-dns.com"
          ];
	  forward-tls-upstream = "yes";
	}
      ];
    };
  };

  networking.resolvconf.enable = true;
  
  services.kresd.enable = lib.mkForce false;
}
