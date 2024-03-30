{ pkgs, nur, ... }: let
  lib = pkgs.lib;
  
  callPackage = lib.callPackageWith (pkgs // { inherit (nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon; } // packages);
  
  packages = {
    catppuccin-alacritty = callPackage ./theming/catppuccin/alacritty { };
    catppuccin-hyprcursor = callPackage ./theming/catppuccin/hyprcursor { };

    firefox-addons = callPackage ./firefox-addons { };
  } // { inherit callPackage; };
in packages