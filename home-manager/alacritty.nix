{ config, ... }: {
  enable = true;
  
  settings = {
    window = {
      padding = {
        x = 6;
        y = 6;
      };
      opacity = 0.8;
    };
    font = {
      family = "monospace";
      size = 10;
    };
    cursor = {
      style = {
        shape = "Beam";
        blinking = "Always";
      };
    };

    import = [
      (pkgs.fetchurl {
        url = "https://github.com/catppuccin/alacritty/raw/main/catppuccin-frappe.yml";
        hash = "";
      })
    ];
  };
}
