{ wallpaper, hyprpaper, ... }: { inputs, pkgs, ... }: {
  xdg.configFile."hypr/hyprpaper.conf" = {
    enable = true;

    text = ''
    preload = ${wallpaper}

    wallpaper = eDP-1,${wallpaper}

    splash = true
    splash_offset = 3.75
    '';
  };

  systemd.user.services."hypridle" = {
    Unit = {
      Description = "Hypr wallpaper daemon";
    };
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
    Service = {
      ExecStart = "${with pkgs; lib.getExe writeScriptBin "hyprpaper" ''
#!${lib.getExe nushell}

${lib.getExe hyprpaper.hyprpaper}
      ''}";
    };
}
