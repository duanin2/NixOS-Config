{ inputs, ... }: let
  nix-colors = inputs.nix-colors;
in {
  colorScheme = nix-colors.colorSchemes.catppuccin-frappe;
}