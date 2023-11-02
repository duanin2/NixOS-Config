{ outputs, lib, config, pkgs, ... }: {
  gtk = {
    enable = true;

    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      name = "FiraCode Nerd Font Mono";
      size = 10;
    };
    catppuccin = {
      enable = true;
      size = "compact";
      tweaks = [ "rimless" ];
    };
  };

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.frappeGreen;
    name = "Catppuccin-Frappe-Green-Cursors";
    size = 28;
    gtk.enable = true;
  };

  qt = {
    enable = true;

    platformTheme = "qtct";
  };

  catppuccin = {
    flavour = "frappe";
    accent = "green";
  };

  home.packages = with pkgs; [ lightly-qt ];
}
