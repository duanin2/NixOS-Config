{ config, pkgs, lib, ... }: let
  cfg = config.services.gnunet;
in {
  services.gnunet = {
    enable = true;

    extraOptions = ''
[arm]
START_SYSTEM_SERVICES = YES
START_USER_SERVICES = NO

[nat]
PUNCHED_NAT = YES
ENABLE_UPNP = NO
EXTERNAL_ADDRESS = 109.80.156.99
    '';
  };

  networking.firewall.allowedUDPPorts = if cfg.udp.port > 0 then [ cfg.udp.port ] else [ ];
  networking.firewall.allowedTCPPorts = if cfg.tcp.port > 0 then [ cfg.tcp.port ] else [ ];

  system.nssModules = with pkgs; [ gnunet ];
  system.nssDatabases.hosts = lib.mkBefore [ "gns [NOTFOUND=return]" ];

  users.users."duanin2".extraGroups = [ "gnunet" ];
}
