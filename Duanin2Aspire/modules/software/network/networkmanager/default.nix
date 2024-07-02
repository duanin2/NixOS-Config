{ ... }: {
  networking.networkmanager = {
    ensureProfiles.profiles."tornet" = {
      connection = {
        id = "tornet";
        type = "bridge";
        interface-name = "tornet";
      };
      ethernet = { };
      bridge = { };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
    };
  };
}
