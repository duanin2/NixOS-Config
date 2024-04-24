{ pkgs, ... }: {
  imports = [
    ../../../../common/iso/no-zfs.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  environment.systemPackages = with pkgs; [
    scx
  ];
}