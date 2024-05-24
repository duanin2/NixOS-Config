{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    fira-code-nerdfont
  ];

  gtk = {
    enable = true;

    theme = lib.mkDefault {
      package = (pkgs.catppuccin-gtk.override {
        variant = "frappe";
        accents = [ "green" ];
      });
    
      name = "Catppuccin-Frappe-Standard-Green-Dark";
    };

    iconTheme = lib.mkDefault {
      package = (pkgs.catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "green";
      });
      
      name = "Papirus-Dark";
    };

    font = lib.mkDefault {
      name = "FiraCode Nerd Font Mono";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-decoration-layout = "";
    };
  };

  fonts.fontconfig.enable = true;
}
