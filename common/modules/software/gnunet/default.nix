{ config, ... }: let
  cfg = config.services.gnunet;
in {
  services.gnunet = {
    enable = true;
  };

  networking.firewall.allowedUDPPorts = [ cfg.udp.port ];
  networking.firewall.allowedTCPPorts = [ cfg.tcp.port ];
}
