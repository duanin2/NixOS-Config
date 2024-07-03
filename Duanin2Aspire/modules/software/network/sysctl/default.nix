{ ... }: {
  boot.kernel.sysctl = {
    "net.ipv4.conf.tornet.route_localnet" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
  };
}
