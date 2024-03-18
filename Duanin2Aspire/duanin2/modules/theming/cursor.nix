{ inputs, config, pkgs, ... }: let
  useHyprcursor = config.wayland.windowManager.hyprland.enable;
in {
  home.pointerCursor = {
    gtk = {
      enable = true;
    };
    package = pkgs.catppuccin-cursors.frappeGreen;
    name = "Catppuccin-Frappe-Green-Cursors";
    size = 24;
  };

  home.packages = if useHyprcursor then [
    (pkgs.callPackage ../../../../packages/hyprcursor-catppuccin.nix {
      hyprcursor = inputs.hyprland.inputs.hyprcursor.packages.${pkgs.system}.hyprcursor;
    }).frappeGreen
  ] else [];
}