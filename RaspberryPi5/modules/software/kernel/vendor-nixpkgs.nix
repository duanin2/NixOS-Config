{ lib, pkgs, ... }: {
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4;
}