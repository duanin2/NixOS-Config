{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    fira-code-nerdfont
  ];

  gtk = {
    enable = true;

    theme = {
      package = (pkgs.catppuccin-gtk.override {
        variant = "frappe";
        accents = [ "green" ];
      });
      name = "Catppuccin-Frappe-Standard-Green-Dark";
    };

    iconTheme = {
      package = (pkgs.catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "green";
      });
      name = "Papirus-Dark";
    };

    font = {
      name = "Fira Code Nerd Font Mono";
      size = 11;
    };
  };
}