{ config, pkgs, ... }: {
  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    cursorTheme = {
      package = pkgs.catppuccin-cursors;
      name = "Catppuccin-Cursors-Frappe-Green";
      size = 10;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    iconTheme = {
      package = (pkgs.catppuccin-gtk.override {
        accents = [ "green" ];
        size = "compact";
        variant = "frappe";
      });
      name = "Catppuccin-Frappe-Compact-Green-dark";
    };
  }
}
