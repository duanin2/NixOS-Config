{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  gtk = {
    enable = true;

    theme = {
      package = (pkgs.colloid-gtk-theme.override {
        tweaks = [ "catppuccin" "rimless" "float" ];
        colorVariants = [ "dark" ];
        themeVariants = [ "green" ];
      }).overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ./colloid.patch
        ];
      });
    
      name = "Colloid-Green-Dark-Catppuccin";
    };

    font = lib.mkDefault {
      name = "FiraCode Nerd Font";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-decoration-layout = "";
    };
  };

  catppuccin.gtk.enable = false;

  fonts.fontconfig.enable = true;
}
