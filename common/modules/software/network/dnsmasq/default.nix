{ lib, ... }: {
  services.dnsmasq = {
    enable = true;

    resolveLocalQueries = true;
    settings = {
      dnssec = true;
      use-stale-cache = 30;
      stop-dns-rebind = true;
      cache-rr = "ANY";
      bogus-priv = true;
      neg-ttl = 30;
      local-ttl = 30;
      server = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
  };

  networking.resolvconf.enable = false;
  
  services.kresd.enable = lib.mkForce false;
}
