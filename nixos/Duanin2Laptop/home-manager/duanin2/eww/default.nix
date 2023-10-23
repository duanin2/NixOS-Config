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
        target = "eww/scripts/tasks.js";
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
