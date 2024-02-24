{ inputs, pkgs, ... }: {
  boot.kernelPackages = inputs.rpi5.legacyPackages.${pkgs.system}.linuxPackages_rpi5;
}