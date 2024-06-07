{ lib, pkgs, ... }: let
  baseExtraPackages = pkgs': extraPackages: with pkgs'; [
    intel-media-driver
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ] ++ extraPackages;
in {
  # Stable
  hardware.opengl = {
    enable = lib.mkForce true;

    extraPackages = baseExtraPackages pkgs (with pkgs; [
      intel-ocl
      intel-compute-runtime
      mesa.opencl
    ]);
    extraPackages32 = baseExtraPackages pkgs.pkgsi686Linux [];
  };

  
  # Git
  chaotic.mesa-git = {
    enable = true;

    method = "replaceRuntimeDependencies";
    extraPackages = baseExtraPackages pkgs (with pkgs; [
      intel-ocl
      intel-compute-runtime
      mesa_git.opencl
    ]);
    extraPackages32 = baseExtraPackages pkgs.pkgsi686Linux [];
  };

  nixpkgs.overlays = [
    /*(final: prev: builtins.mapAttrs (name: value: lib.overrideAll {
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
