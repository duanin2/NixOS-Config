{ pkgs, modules, ... }: {
  imports = [
    (modules.iso + /no-zfs.nix)
  ];

  boot.kernelPackages = pkgs.pkgsx86_64_v3.linuxPackages_cachyos-lto;
  services.scx = {
    enable = true;
    package = pkgs.pkgsx86_64_v3.scx_git.full;

    scheduler = "scx_lavd";
  };
}
