{ lib, config, pkgs, ... }: {
  gtk = {
    enable = true;

    cursorTheme = {
      package = pkgs.catppuccin-cursors;
      name = "Catppuccin-Cursors-Frappe-Green";
      size = 24;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    theme = {
      package = (pkgs.catppuccin-gtk.override {
        accents = [ "green" ];
        size = "compact";
        variant = "frappe";
      });
      name = "Catppuccin-Frappe-Compact-Green-dark";
    };
    preferDarkTheme = true;
  };
}
