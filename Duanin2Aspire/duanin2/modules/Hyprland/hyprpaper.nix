{ wallpaper, hyprpaper, ... }: { pkgs, customPkgs, lib, ... }: {
  xdg.configFile."hypr/hyprpaper.conf" = {
    enable = true;

    text = ''
    preload = ${wallpaper}

    wallpaper = eDP-1,${wallpaper}

    splash = true
    splash_offset = 3.75
    '';
  };

  systemd.user.services."hyprpaper" = {
    Unit = {
      Description = "Hypr wallpaper daemon";
    };
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
    Service = {
      ExecStart = customPkgs.systemdScript "hyprpaper" "sh -c ${lib.getExe hyprpaper.hyprpaper}";
    };
  };
}
