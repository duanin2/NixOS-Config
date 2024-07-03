{ ... }: {
  networking.firewall = {
    interfaces."tornet" = {
      allowedTCPPorts = [ 9040 9050 ];
      allowedUDPPorts = [ 53 ];
    };
  };
}
