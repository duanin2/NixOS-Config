{ ... }: {
  zramSwap = {
    enable = true;

    algorithm = "zstd";
    swapDevices = 1;
    memoryPercent = 100;
    priority = 32767;
  };
}