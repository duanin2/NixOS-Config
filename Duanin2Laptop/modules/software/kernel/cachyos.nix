{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  environment.systemPackages = with pkgs; [
    scx
  ];
}