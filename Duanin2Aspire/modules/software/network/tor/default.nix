{ ... }: {
  services.tor = {
    enable = true;

    openFirewall = true;
    client.dns.enable = true;
    settings = {
      DNSPort = [
        { addr = "127.0.0.1"; port = 53; }
      ];
      TransPort = [ 9040 ];
      VirtualAddrNetworkIPv4 = "172.30.0.0/16";
    };
  };
}
