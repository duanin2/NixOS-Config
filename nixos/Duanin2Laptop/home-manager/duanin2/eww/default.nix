{ pkgs, ... }: let
  args = { inherit pkgs tasks menu; };
  
  tasks = pkgs.writeScript "tasks.js" (import ./tasks.nix args);
  menu = pkgs.writeScript "menu.js" (import ./menu.nix args);
in {
  xdg = {
    configFile = {
      "eww.yuck" = {
        target = "eww/eww.yuck";
        text = (import ./eww.nix args);
      };
    };
    
    dataFile = {
      "images" = {
        enable = true;
        recursive = true;
        source = ./images;
        target = "eww/images";
      };
    };
  };

  home.packages = with pkgs; [
    (eww-wayland.overrideAttrs (old: rec {
      patches = (old.patches or []) ++ [
        (fetchpatch {
          url = "https://github.com/ralismark/eww/pull/4.patch";
          hash = "sha256-tORGA5lXwDE3n3rYhaxBdt1Z4ZxBENTQIJhv3Hbl5yU=";
        })
      ];
    }))
  ];
}
