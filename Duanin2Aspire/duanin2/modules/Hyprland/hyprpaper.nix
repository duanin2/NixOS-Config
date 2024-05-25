{ wallpaper, ... }: { inputs, pkgs, ... }: {
  xdg.configFile."hypr/hyprpaper.conf" = {
    enable = true;

    text = ''
    preload = ${wallpaper}

    wallpaper = eDP-1,${wallpaper}

    splash = true
    splash_offset = 3.75
    '';
  };
}
