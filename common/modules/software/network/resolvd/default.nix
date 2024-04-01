{ ... }: {
  networking.nameservers = [ "194.242.2.4#base.dns.mullvad.net" ];

  services.resolved = {
    enable = true;
    dnssec = "false";
    dnsovertls = "true";
    domains = [ "~." ];
    fallbackDns = [ "192.168.1.1" ];
  };

  networking.resolvconf.enable = false;
}
