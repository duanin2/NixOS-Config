# This file defines overlays
{ inputs, lib, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };
  
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    prismlauncher = inputs.prismlauncher.packages.${final.system}.prismlauncher.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (prev.fetchpatch {
          url = "https://github.com/cs32767/PrismLauncher-Offline/commit/17de713e47379dbbc46236eb489f4e4a824a4fee.patch";
          hash = "sha256-M0LOiik7lx9y5K9rX416tLn5otrtmX71toI4Mw8Om10=";
        })
      ];
    });
    python311Packages.keyutils = inputs.nixpkgs-master.legacyPackages.${final.system}.python311Packages.keyutils;
  };
}
