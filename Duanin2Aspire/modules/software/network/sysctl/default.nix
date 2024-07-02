{ ... }: {
  boot.kernel.sysctl = {
    "net.ipv4.conf.tornet.route_localnet" = 1;
  };
}
