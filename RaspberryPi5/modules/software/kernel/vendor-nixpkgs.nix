{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
}