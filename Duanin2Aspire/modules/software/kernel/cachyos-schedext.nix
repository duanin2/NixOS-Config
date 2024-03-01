{ pkgs, ... }: {
  # Deprecated, as the sched-ext patches are now in 'cachyos' variant

  boot.kernelPackages = pkgs.linuxPackages_cachyos-sched-ext;
  environment.systemPackages = with pkgs; [
    scx
  ];
}