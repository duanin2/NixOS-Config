{ ... }: {
  networking.nameservers = [ "194.242.2.2#dns.mullvad.net" ];

  services.resolved = {
    enable = true;
    
    dnssec = "false";
    dnsovertls = "true";
    domains = [ "~." ];
    fallbackDns = [ "" ];

    llmnr = "false";
    extraConfig = ''
MulticastDNS=false
    '';
  };

  networking.resolvconf.enable = false;
}
