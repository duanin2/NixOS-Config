{ ... }: {
  xdg = {
    configFile = {
      "eww.yuck" = {
        target = "eww/eww.yuck";
        source = ./eww.yuck;
      };
    };
    
    dataFile = {
      "images" = {
        enable = true;
        recursive = true;
        source = ./images;
        target = "eww/images";
      };
      "scripts/tasks.js" = {
        enable = true;
        text = import ./tasks.nix;
        target = "eww/scripts/tasks.nix";
      };
    };
  };
}
