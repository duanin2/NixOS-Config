{ hyprlock, hypridle, ... }: { pkgs, lib, ... }: {
  xdg.configFile."hypr/hypridle.conf" = {
    enable = true;

    text = ''
    general {
      lock_cmd = pidof hyprlock || ${lib.getExe hyprlock.hyprlock}
      unlock_cmd = ${lib.getExe pkgs.nushell} -c "ps -l | where { $in.user_id == 1000 and ($in.name == ${lib.getExe hyprlock.hyprlock}) } | par-each { kill -s 10 $in.pid }"
      before_sleep_cmd = loginctl lock-session
      after_sleep_cmd = hyprctl dispatch dpms on
      ignore_dbus_inhibit = false
    }

    listener {
      timeout = 10
      on-timeout = ${lib.getExe pkgs.brightnessctl} -s set 1%
      on-resume = ${lib.getExe pkgs.brightnessctl} -r
    }

    listener {
      timeout = 20
      on-timeout = hyprctl dispatch dpms off
      on-resume = hyprctl dispatch dpms on
    }

    listener {
      timeout = 30
      on-timeout = loginctl lock-session
      on-resume = hyprctl dispatch dpms on
    }

    listener {
      timeout = 60
      on-timeout = systemctl suspend
      on-resume = hyprctl dispatch dpms on
    }
    '';
  };

  systemd.user.services."hypridle" = {
    Unit = {
      Description = "Hypr idle daemon";
    };
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
    Service = {
      ExecStart = "${with pkgs; lib.getExe writeScriptBin "hypridle" ''
#!${lib.getExe nushell}

${lib.getExe hypridle.hypridle}
      ''}";
    };
  };
}
