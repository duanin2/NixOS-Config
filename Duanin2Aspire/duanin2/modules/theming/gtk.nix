{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    fira-code-nerdfont
  ];

  gtk = {
    enable = true;

    catppuccin.enable = false;

    theme = {
      package = (pkgs.colloid-gtk-theme.override {
        tweaks = [ "catppuccin" "rimless" "float" ];
        colorVariants = [ "dark" ];
        themeVariants = [ "green" ];
      });
    
      name = "Colloid-Green-Dark-Catppuccin";
    };

    font = lib.mkDefault {
      name = "FiraCode Nerd Font Propo";
      size = 10;
    };

    gtk3.extraConfig = {
      gtk-decoration-layout = "";
    };
  };

  fonts.fontconfig.enable = true;
}
