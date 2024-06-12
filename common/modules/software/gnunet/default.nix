{ config, ... }: let
  cfg = config.services.gnunet;
in {
  services.gnunet = {
    enable = true;

    extraConfig = ''
[arm]
START_SYSTEM_SERVICES = YES
START_USER_SERVICES = NO
    '';
  };

  networking.firewall.allowedUDPPorts = [ cfg.udp.port ];
  networking.firewall.allowedTCPPorts = [ cfg.tcp.port ];

  users.users."duanin2".extraGroups = [ "gnunet" ];
}
