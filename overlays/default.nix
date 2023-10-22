# This file defines overlays
{ inputs, lib, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };
  
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    prismlauncher = inputs.prismlauncher.packages.${prev.system}.prismlauncher.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (prev.fetchpatch {
          url = "https://github.com/cs32767/PrismLauncher-Offline/commit/17de713e47379dbbc46236eb489f4e4a824a4fee.patch";
          hash = "sha256-M0LOiik7lx9y5K9rX416tLn5otrtmX71toI4Mw8Om10=";
        })
      ];
    });
  };

  # mesa git
  mesa = final: prev: let
    newAttrs = {
      galliumDrivers = [
        "swrast"
        "zink"
        "iris"
      ];
      vulkanDrivers = [
        "swrast"
        "intel"
      ];
    };
  in rec {
    mesa = inputs.chaotic.packages.x86_64-linux.mesa_git.override newAttrs;
    pkgsi686Linux.mesa = inputs.chaotic.packages.x86_64-linux.final.mesa32_git.override newAttrs;
  };
}
