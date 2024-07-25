{ wallpaper, hyprpaper, ... }: { pkgs, customPkgs, lib, ... }: {
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

  systemd.user.services."hyprpaper" = {
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      Before = [ "hyprland-session.target" ];
    };
  };
}
