{ pkgs, nur, hyprcursor, ... }: let
  lib = pkgs.lib;
  
  callPackage = lib.callPackageWith (pkgs // { inherit (nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon; inherit hyprcursor; } // packages);
  
  packages = rec {
    catppuccin-alacritty = callPackage ./theming/catppuccin/alacritty { };
    catppuccin-hyprcursor = callPackage ./theming/catppuccin/hyprcursor { };

    mozilla = callPackage ./mozilla { };

    scripts = callPackage ./scripts { };
    ueventNu = scripts.uevent;
    nmcliNu = scripts.nmcli;
  } // { inherit callPackage; };
in packages
