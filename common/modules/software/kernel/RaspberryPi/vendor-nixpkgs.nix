{ lib, pkgs, ... }: {
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4;

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
}
