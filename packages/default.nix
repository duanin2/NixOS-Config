{ pkgs, nur, hyprcursor, ... }: let
  lib = pkgs.lib;
  
  callPackage = lib.callPackageWith (pkgs // { inherit (nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon; inherit hyprcursor; } // packages);
  
  packages = {
    catppuccin-alacritty = callPackage ./theming/catppuccin/alacritty { };
    catppuccin-hyprcursor = callPackage ./theming/catppuccin/hyprcursor { };

    mozilla = callPackage ./mozilla { };

    overrideAll = package: args: attrs: callPackage (import ./overrideAll.nix { inherit package args attrs; }) { };
  } // { inherit callPackage; };
in packages
