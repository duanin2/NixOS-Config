{ modules, ... }: {
  imports = [
    (modules.common.software + /chrony)
  ];

  services.chrony = {
    servers = map (value: "${toString value}.cz.pool.ntp.org") [ 0 1 2 3 ];
    serverOption = "iburst";
    extraConfig = ''
refclock PHC /dev/ptp0
    '';
  };
}