{ ... }: {
  services.resolved = {
    enable = true; # For caching DNS requests.
    fallbackDns = [ "" ]; # Overwrite compiled-in fallback DNS servers
  };

  networking.nameservers = [ "127.0.0.1" ];
}
