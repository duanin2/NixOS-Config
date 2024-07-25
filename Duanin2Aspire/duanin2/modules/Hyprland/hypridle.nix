{ hyprlock, hypridle, hyprland, ... }: { pkgs, customPkgs, lib, ... }: {
  services.hypridle = {
    enable = true;
    package = hypridle.hypridle;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${lib.getExe hyprlock.hyprlock}";
        unlock_cmd = "${lib.getExe pkgs.nushell} -c 'ps -l | where { $in.user_id == (id -u) and ($in.name == ${lib.getExe hyprlock.hyprlock}) } | par-each { kill -s 10 $in.pid }'";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 10;
          on-timeout = "${lib.getExe pkgs.brightnessctl} -s set 1%";
          on-resume = "${lib.getExe pkgs.brightnessctl} -r";
        }
        {
          timeout = 30;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 60;
          on-timeout = "loginctl lock-session";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 90;
          on-timeout = "systemctl suspend";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ];
    };
  };

  systemd.user.services.hypridle = {
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      Before = [ "hyprland-session.target" ];
    };
  };
}
