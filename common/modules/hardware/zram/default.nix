{ ... }: {
  zramSwap = {
    enable = true;

    algorithm = "zstd";
    swapDevices = 1;
    memoryPercent = 50;
    priority = 32767;
  };
}
