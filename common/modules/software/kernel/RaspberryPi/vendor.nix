{ inputs, lib, pkgs, ... }: {
  boot.kernelPackages = lib.mkForce inputs.rpi5.legacyPackages.${pkgs.system}.linuxPackages_rpi5;

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
}
