{ customPkgs, pkgs, ... }: {
  chaotic.mesa-git = {
    enable = true;
  };

  nixpkgs.overlays = [
    (final: prev: builtins.mapAttrs (name: value: customPkgs.overrideAll
      value
      (old: {
        galliumDrivers = [
          "swrast"
          "v3d"
          "vc4"
        ];
        vulkanDrivers = [
          "swrast"
          "broadcom"
        ];
      })
      (old: {
        mesonFlags = (old.mesonFlags or []) ++ [
          "-Dgallium-vdpau=disabled"
          "-Dgallium-va=disabled"
          "-Dgallium-xa=disabled"
          "-Dintel-rt=disabled"
        ];
      })
    ) { inherit (prev) mesa_git; })
  ];
}