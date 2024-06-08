{ ... }: {
  systemd.oomd = {
    enable = true;

    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;

    extraConfig = {
      SwapUsedLimit = "80%";
      DefaultMemoryPressureLimit = "80%";
      DefaultMemoryPressureDurationSec = "10sec";
    };
  };
}
