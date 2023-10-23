{ outputs, lib, config, pkgs, ... }: {
  gtk = {
    enable = true;

    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      name = "FiraCode Nerd Font Mono";
      size = 10;
    };
    theme = {
      package = (pkgs.catppuccin-gtk.override {
        accents = [ "green" ];
        size = "compact";
        variant = "frappe";
      });
      name = "Catppuccin-Frappe-Compact-Green-Dark";
    };
    preferDarkTheme = true;
  };

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.frappeGreen;
    name = "Catppuccin-Frappe-Green-Cursors";
    size = 28;
    gtk.enable = true;
  };

  home.packages = with pkgs; [
    catppuccin-kvantum
  ];

  qt = {
    enable = true;

    platformTheme = "qtct";
    style = {
      package = pkgs.libsForQt5.kvantum;
      name = "kvantum";
    };
  };
}
