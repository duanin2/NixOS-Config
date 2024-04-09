{ customPkgs, pkgs, ... }: {
  chaotic.mesa-git = {
    enable = true;

    extraPackages = with pkgs; [ mesa_git.opencl intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl intel-ocl intel-compute-runtime ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl ];
  };

  nixpkgs.overlays = [
    /* (final: prev: builtins.mapAttrs (name: value: lib.overrideAll {
      package = value;
      args = (old: {
        galliumDrivers = [
          "nouveau"
          "swrast"
          "iris"
        ];
        vulkanDrivers = [
          "nouveau"
          "swrast"
          "intel"
        ];
      });
    }) { inherit (prev) mesa_git mesa32_git; })*/
  ];
}