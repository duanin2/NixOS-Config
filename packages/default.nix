{ pkgs, ... }: let
  lib = pkgs.lib;
  
  callPackage = lib.callPackageWith packages;
  
  packages = {
    catppuccin-alacritty = callPackage ./theming/catppuccin/alacritty { };
    catppuccin-hyprcursor = callPackage ./theming/catppuccin/hyprcursor { };
  } // { inherit callPackage; };
in packages