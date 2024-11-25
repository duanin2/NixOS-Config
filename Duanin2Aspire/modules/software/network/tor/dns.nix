{ modules, lib, ... }: {
  imports = [
    (modules.common.software.network + /resolvd)
    ./default.nix
  ];
  
  services = {
    resolved = {
      enable = true; # For caching DNS requests.
      dnssec = lib.mkForce "false";
      dnsovertls = lib.mkForce "false";
      fallbackDns = [ "" ]; # Overwrite compiled-in fallback DNS servers
    };
    tor = {
      client.dns.enable = true;
      settings.DNSPort = lib.mkForce [ { addr = "127.0.0.1"; port = 53; } ];
    };
  };

  networking.nameservers = lib.mkForce [ "127.0.0.1" ];
}
