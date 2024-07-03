{ lib, ... }: {
  services.resolved = {
    enable = true; # For caching DNS requests.
    dnssec = lib.mkForce "false";
    dnsovertls = lib.mkForce "false";
    fallbackDns = [ "" ]; # Overwrite compiled-in fallback DNS servers
  };

  networking.nameservers = lib.mkForce [ "127.0.0.1" ];
}
