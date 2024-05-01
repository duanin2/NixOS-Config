{ pkgs, ... }: {
  home.pointerCursor = {
    gtk = {
      enable = true;
    };
    package = pkgs.catppuccin-cursors.frappeGreen;
    name = "Catppuccin-Frappe-Green-Cursors";
    size = 24;
  };
}