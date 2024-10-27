{ config, lib, ... }: {
  services.dnsmasq = {
    enable = true;

    resolveLocalQueries = true;
    settings = {
      listen-address = "::1,127.0.0.1,127.0.0.53";
      cache-size = 10000;
      conf-file = "${config.services.dnsmasq.package}/share/dnsmasq/trust-anchors.conf";
      dnssec = true;
      use-stale-cache = 60;
      stop-dns-rebind = true;
      cache-rr = "ANY";
      bogus-priv = true;
      neg-ttl = 60;
      local-ttl = 60;
      log-async = 25;
      server = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
  };

  networking.resolvconf.enable = true;
  
  services.kresd.enable = lib.mkForce false;
}
