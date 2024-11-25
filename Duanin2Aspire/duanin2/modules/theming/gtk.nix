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

  fonts.fontconfig.enable = true;
}
