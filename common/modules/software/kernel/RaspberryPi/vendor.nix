{ inputs, lib, pkgs, ... }: {
  boot.kernelPackages = lib.mkForce inputs.rpi5.legacyPackages.${pkgs.system}.linuxPackages_rpi5;
}
