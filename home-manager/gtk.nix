{ config, pkgs, ... }: let
  preferDarkTheme = true;
in {
  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    gtk3.extraConfig = ''
gtk-application-prefer-dark-theme=${if (preferDarkTheme or false) then "true" else "false"}
    '';

    gtk4.extraConfig = ''
gtk-application-prefer-dark-theme=${if (preferDarkTheme or false) then "true" else "false"}
    '';

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
  };
}
