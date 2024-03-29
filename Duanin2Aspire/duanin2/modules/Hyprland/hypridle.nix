{ hyprland, hyprland-plugins, hyprpaper, hyprpicker, hypridle, hyprlock}: { pkgs, lib, ... }: {
  xdg.configFile."hypr/hypridle.conf" = {
    enable = true;

    text = ''
    general {
      lock_cmd = pidof hyprlock || ${hyprlock.hyprlock}/bin/hyprlock
      before_sleep_cmd = loginctl lock-session
      after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
      timeout = 60
      on-timeout = ${lib.getExe pkgs.brightnessctl} -s set 5%
      on-resume = ${lib.getExe pkgs.brightnessctl} -r
    }

    listener {
      timeout = 120
      on-timeout = loginctl lock-session
    }
    
    listener {
      timeout = 150
      on-timeout = hyprctl dispatch dpms off
      on-resume = hyprctl dispatch dpms on
    }

    listener {
      timeout = 300
      on-timeout = systemctl suspend
    }
    '';
  };
}