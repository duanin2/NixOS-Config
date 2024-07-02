{ ... }: {
  networking.nameservers = [ "194.242.2.4#base.dns.mullvad.net" ];

  services.resolved = {
    enable = true;
    dnssec = "false";
    dnsovertls = "true";
    domains = [ "~." ];
    fallbackDns = [ "" ];
  };

  networking.resolvconf.enable = false;
}
