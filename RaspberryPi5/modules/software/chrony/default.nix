{ modules, ... }: {
  imports = [
    (modules.common.software + /chrony)
  ];

  services.chrony = {
    servers = map (value: "${toString value}.cz.pool.ntp.org") [ 0 1 2 3 ];
    serverOption = "iburst";
  };

  boot.kernelPatches = [
    {
      name = "Chrony RTC Fix";
      patch = "/dev/null";
      extraConfig = "RTC_INTF_DEV_UIE_EMUL y";
    }
  ];
}