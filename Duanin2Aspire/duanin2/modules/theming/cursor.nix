{ inputs, config, pkgs, customPkgs, ... }: let
  hyprlandCfg = config.wayland.windowManager.hyprland;
in {
  home.pointerCursor = {
    gtk = {
      enable = true;
    };
    package = pkgs.catppuccin-cursors.frappeGreen;
    name = "Catppuccin-Frappe-Green-Cursors";
    size = 24;
  };

  home.packages = if hyprlandCfg.enable then [
    (customPkgs.catppuccin-hyprcursor.override { inherit (inputs.hyprland.inputs.hyprcursor.packages.${pkgs.system}) hyprcursor; }).frappeGreen
  ] else [];
}