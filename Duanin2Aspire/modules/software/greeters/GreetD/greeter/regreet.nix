{ lib, config, pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    ((pkgs.colloid-gtk-theme.override {
      tweaks = [ "catppuccin" "rimless" "float" ];
      colorVariants = [ "dark" ];
      themeVariants = [ "green" ];
    }).overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./colloid.patch
      ];
    }))
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
        application_prefer_dark_theme = lib.mkForce true;
        cursor_theme_name = lib.mkForce "Catppuccin-Frappe-Green-Cursors";
        cursor_theme_size = lib.mkForce 24;
        font_name = lib.mkForce "FiraCode Nerd Font 10";
        icon_theme_name = lib.mkForce "Papirus-Dark";
        theme_name = lib.mkForce "Colloid-Green-Dark-Catppuccin";
      };
    };
  };
}
