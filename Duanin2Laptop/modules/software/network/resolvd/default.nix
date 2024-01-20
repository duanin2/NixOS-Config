{ ... }: {
  networking.nameservers = [ "194.242.2.4#base.dns.mullvad.net" ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "192.168.1.1" ];
    extraConfig = ''
      DNSOverTLS=opportunistic
    '';
  };

  networking.resolvconf.enable = false;
}