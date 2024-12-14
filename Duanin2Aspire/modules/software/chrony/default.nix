{ modules, ... }: {
  imports = [
    (modules.common.software + /chrony)
  ];

  services.chrony = {
    servers = map (value: "${toString value}.pool.ntp.org") [ 0 1 2 3 ];
    serverOption = "offline";
  };
}