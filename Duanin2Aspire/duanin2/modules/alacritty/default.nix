{ config, ... }: let
  fontCfg = config.gtk.font;
in {
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 0.8;
      };

      font = {
        normal = {
          family = fontCfg.name;
        };
        inherit (fontCfg) size;
      };

      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };

      debug = {
        prefer_egl = true;
      };
    };
  };
}
