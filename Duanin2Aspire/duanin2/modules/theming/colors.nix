{ inputs, ... }: let
  inherit (inputs) nix-colors;
in {
  imports = [ nix-colors.homeManagerModule ];
  colorScheme = nix-colors.colorSchemes.catppuccin-frappe;
}