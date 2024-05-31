{ config, pkgs, ... }: {
  fonts.packages = with pkgs; [
    fira-code-nerdfont
  ];

  environment.systemPackages = with pkgs; [
    (catppuccin-gtk.override {
      variant = "frappe";
      accents = [ "green" ];
    })
    (catppuccin-papirus-folders.override {
      flavor = "frappe";
      accent = "green";
    })
    catppuccin-cursors.frappeGreen
  ];

  programs.regreet = {
    enable = true;

    settings = {
      GTK = {
        application_prefer_dark_theme = true;
        cursor_theme_name = "Catppuccin-Frappe-Green-Cursors";
        cursor_theme_size = 24;
        font_name = "FiraCode Nerd Font Propo 11";
        icon_theme_name = "Papirus-Dark";
        theme_name = "Catppuccin-Frappe-Standard-Green-Dark";
      };
    };
  };
}
