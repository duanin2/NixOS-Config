{ lib, pkgs, ... }: let
  baseExtraPackages = pkgs': extraPackages: with pkgs'; [
    vaapiVdpau
  ] ++ extraPackages;
in {
  # Stable
  hardware.graphics = {
    extraPackages = baseExtraPackages pkgs (with pkgs; [
      mesa.opencl
    ]);
    extraPackages32 = baseExtraPackages pkgs.pkgsi686Linux [];
  };

  
  # Git
  chaotic.mesa-git = {
    enable = true;

    extraPackages = baseExtraPackages pkgs (with pkgs; [
      mesa_git.opencl
    ]);
    extraPackages32 = baseExtraPackages pkgs.pkgsi686Linux [];
  };

  nixpkgs.overlays = let
    newMesa = package: lib.overrideAll {
      inherit package;
      args = (old: {
        galliumDrivers = [
          "nouveau"
          "swrast"
          "iris"
          "zink"
        ];
        vulkanDrivers = [
          "nouveau"
          "swrast"
          "intel"
        ];
      });
    };
  in [
    #(final: prev: {
    #  mesa = newMesa prev.pkgsx86_64_v3.mesa;
    #  pkgsi686Linux = prev.pkgsi686Linux // {
    #    mesa = newMesa prev.pkgsi686Linux.mesa;
    #  };
    #  mesa_git = newMesa prev.pkgsx86_64_v3.mesa_git;
    #  mesa32_git = newMesa prev.mesa32_git;
    #})
  ];
}
