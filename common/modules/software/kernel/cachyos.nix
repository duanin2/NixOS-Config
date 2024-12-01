{ pkgs, modules, ... }: {
  imports = [
    (modules.iso + /no-zfs.nix)
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
  services.scx = {
    enable = true;
    package = pkgs.scx_git.full;

    scheduler = "scx_lavd";
  };
}
