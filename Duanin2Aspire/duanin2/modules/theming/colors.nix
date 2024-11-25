{ inputs, ... }: let
  inherit (inputs) nix-colors;
in with nix-colors; {
  imports = [ homeManagerModule ];
  colorScheme = with colorSchemes; catppuccin-frappe;
}
