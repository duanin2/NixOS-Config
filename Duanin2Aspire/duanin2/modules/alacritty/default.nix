{ config, customPkgs, ... }: let
  fontCfg = config.gtk.font;
in {
  programs.alacritty = {
    enable = true;

    settings = {
      general = {
        import = [
          "${customPkgs.catppuccin-alacritty.frappe}/alacritty.toml"
        ];
      };

      window = {
        opacity = 0.2;
      };

      font = {
        normal = {
          family = fontCfg.name;
          inherit (fontCfg) size;
        };
      };

      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };
    };
  };
}