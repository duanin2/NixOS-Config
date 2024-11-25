{ lib, pkgs, ... }: {
  /*
  chaotic.mesa-git = {
    enable = true;
  };
  */

  hardware.graphics = {
    enable = true;
  };

  nixpkgs.overlays = [
    /*
    (final: prev: builtins.mapAttrs (name: value: lib.overrideAll {
      package = value;
      args = (old: {
        galliumDrivers = [
          "swrast"
          "v3d"
          "vc4"
          "zink"
        ];
        vulkanDrivers = [
          "swrast"
          "broadcom"
        ];
      });
      attrs = (old: {
        mesonFlags = (old.mesonFlags or []) ++ [
          "-Dgallium-vdpau=disabled"
          "-Dgallium-va=disabled"
          "-Dgallium-xa=disabled"
          "-Dintel-rt=disabled"
          "-Dgallium-nine=disabled"
        ];
      });
    }) { inherit (prev) mesa_git; })
    */
  ];
}
