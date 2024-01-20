{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_cachyos-sched-ext;
  environment.systemPackages = with pkgs; [
    scx
  ];
}