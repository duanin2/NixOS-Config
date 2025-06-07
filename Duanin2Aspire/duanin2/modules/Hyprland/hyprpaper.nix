{ hyprpaper, ... }: { pkgs, customPkgs, lib, wallpaper, ... }: {
  services.hyprpaper = {
    enable = true;
    package = hyprpaper.hyprpaper;

    settings = {
      preload = "${wallpaper}";

      wallpaper = "eDP-1,${wallpaper}";

      splash = true;
      splash_offset = 3.75;
    };
  };

  wayland.windowManager.hyprland.settings.exec-once = [ (lib.getExe hyprpaper.hyprpaper) ];
}
