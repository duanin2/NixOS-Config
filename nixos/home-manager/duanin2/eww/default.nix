{ pkgs, ... }: {
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
        executable = true;
        text = (import ./tasks.nix { inherit pkgs; });
        target = "eww/scripts/tasks.nix";
      };
    };
  };
}
