{ pkgs, ... }: {
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.frappeGreen;

    gtk = {
      enable = true;
    };
    name = "Catppuccin-Frappe-Green-Cursors";
    size = 24;
  };
}
