{ ... }: {
  networking.firewall = {
    interfaces."tornet" = {
      allowedTCPPorts = [ 9040 ];
      allowedUDPPorts = [ 5353 ];
    };
  };
}
