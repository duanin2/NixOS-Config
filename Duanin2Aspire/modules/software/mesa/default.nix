{ customPkgs, pkgs, ... }: {
  chaotic.mesa-git = {
    enable = true;

    extraPackages = with pkgs; [ mesa_git.opencl intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl intel-ocl intel-compute-runtime ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl ];
  };

  nixpkgs.overlays = [
    (final: prev: builtins.mapAttrs (name: value: customPkgs.overrideAll
      value
      (old: {
        galliumDrivers = [
          "nouveau"
          "swrast"
          "iris"
        ];
        vulkanDrivers = [
          "nouveau-experimental"
          "swrast"
          "intel"
        ];
      })
      (old: { })
    ) { inherit (prev.pkgsx86_64_v3) mesa_git mesa32_git; })
  ];
}