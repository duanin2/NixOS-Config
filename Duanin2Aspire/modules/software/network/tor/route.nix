{ modules, ... }: {
  imports = [
    (modules.common.software.network + /networkmanager)
    (modules.common.software.network + /firewall)
    ./default.nix
  ];

  services.tor.client.transparentProxy.enable = true;
  
  networking = {
    networkmanager = {
      ensureProfiles.profiles."tornet" = {
        connection = {
          id = "tornet";
          type = "bridge";
          interface-name = "tornet";
          autoconnect = true;
        };
        ethernet = { };
        bridge = {
          interface-name = "tornet";
        };
        ipv4 = {
          address1 = "10.100.100.1/24";
          method = "manual";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
      };
    };
    nftables = {
      enable = true;

      flushRuleset = true;
      ruleset = ''
table ip nat {
  chain PREROUTING {
    type nat hook prerouting priority dstnat; policy accept;
    iifname "tornet" meta l4proto tcp dnat to 127.0.0.1:9040
    iifname "tornet" udp dport 53 dnat to 127.0.0.1:53
    iifname "tornet" tcp dport 9050 dnat to 127.0.0.1:9050
  }
}
    '';
    };
    firewall = {
      interfaces."tornet" = {
        allowedTCPPorts = [ 9040 9050 ];
        allowedUDPPorts = [ 53 ];
      };
    };
  };
  
  boot.kernel.sysctl = {
    "net.ipv4.conf.tornet.route_localnet" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
  };
}
