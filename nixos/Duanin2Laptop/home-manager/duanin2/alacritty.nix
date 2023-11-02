{ config, pkgs, ... }: {
  enable = true;

  catppuccin.enable = true;
  settings = {
    window = {
      padding = {
        x = 6;
        y = 6;
      };
      opacity = 0.8;
    };
    font = {
      family = "FiraCode Nerd Font Mono";
      size = 10;
    };
    cursor = {
      style = {
        shape = "Beam";
        blinking = "Always";
      };
    };
  };
}
