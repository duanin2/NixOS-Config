{ config, pkgs, lib, ... }: let
  cfg = config.services.gnunet;
in {
  services.gnunet = {
    enable = true;

    extraOptions = ''
[arm]
START_SYSTEM_SERVICES = YES
START_USER_SERVICES = NO
    '';
  };

  networking.firewall.allowedUDPPorts = [ cfg.udp.port ];
  networking.firewall.allowedTCPPorts = [ cfg.tcp.port ];

  system.nssModules = with pkgs; [ gnunet ];
  system.nssDatabases.hosts = lib.mkBefore [ "gns [NOTFOUND=return]" ];

  users.users."duanin2".extraGroups = [ "gnunet" ];
}
