{ ... }: {
  services.avahi = {
    enable = true;
    
    ipv4 = true;
    ipv6 = true;
    nssmdns = true;
  };
}
