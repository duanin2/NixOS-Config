{ modules, ... }: {
  imports = [
    (modules.common.software.network + /unbound)
  ];

  services.unbound.settings.forward-zone = {
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
      forward-ssl-upstream = "yes";
    }
  };
}
