{ ... }: {
  services.tor = {
    enable = true;

    openFirewall = true;
    client = {
      enable = true;
      dns.enable = true;
      transparentProxy.enable = true;

      socksListenAddress = { addr = "127.0.0.1"; port = 9050; };
    };
    settings = {
      VirtualAddrNetworkIPv4 = "172.30.0.0/16";
      DNSPort = [ { addr = "127.0.0.1"; port = 53; } ];
    };
  };
}
