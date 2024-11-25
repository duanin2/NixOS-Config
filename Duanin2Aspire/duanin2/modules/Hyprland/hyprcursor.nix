{ hyprcursor, ... }: { config, customPkgs, ... }: {
  home.packages = [
    (customPkgs.catppuccin-hyprcursor.override { inherit (hyprcursor) hyprcursor; }).frappeGreen
  ];

  wayland.windowManager.hyprland.settings.env = [
    # Hyprcursor
    "HYPRCURSOR_THEME, Catppuccin-Frappe-Green-Hyprcursors"
    "HYPRCURSOR_SIZE, ${toString config.home.pointerCursor.size}"
  ];
}