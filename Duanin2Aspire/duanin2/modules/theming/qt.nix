{ pkgs, ... }: {
  qt = {
    enable = true;

    style.name = "kvantum";
  };

  xdg.configFile = let
    accent = "Green";
    variant = "Frappe";
  in {
    "Kvantum/kvantum.kvconfig" = {
      enable = true;

      text = "theme=nixTheme";
    };
    "Kvantum/nixTheme" = {
      enable = true;
      recursive = true;

      source = "${pkgs.catppuccin-kvantum.override { inherit accent variant; }}/share/Kvantum/Catppuccin-${variant}-${accent}/";
    };
  };
}
