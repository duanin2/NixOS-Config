{ ... }: {
  networking.networkmanager = {
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
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
    };
  };
}
