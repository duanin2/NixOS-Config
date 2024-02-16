{ ... }: {
  boot.kernelParams = [
    "i915.enable_psr=0"
  ];
}