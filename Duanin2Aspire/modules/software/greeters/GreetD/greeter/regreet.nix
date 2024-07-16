{ config, pkgs, ... }: {
  fonts.packages = with pkgs; [
    fira-code-nerdfont
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.colloid-gtk-theme.override {
      tweaks = [ "catppuccin" "rimless" "float" ];
      colorVariants = [ "dark" ];
      themeVariants = [ "green" ];
    }).overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./colloid.patch
      ];
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
        font_name = "FiraCode Nerd Font 10";
        icon_theme_name = "Papirus-Dark";
        theme_name = "Colloid-Green-Dark-Catppuccin";
      };
    };
  };
}
