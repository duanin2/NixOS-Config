{pkgs,...}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar-hyprland;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = ["wlr/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["pulseaudio" "backlight" "hyprland/language" "battery" "clock" "tray" "custom/notification"];
        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        "temperature" = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        "backlight" = {
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon} ";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon} ";
          format-icons = ["" "" "" "" ""];
        };
        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pgrep pavucontrol || pavucontrol && pkill pavucontrol";
        };
        "wlr/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          on-click = "activate";
        };
        "hyprland/language" = {
          format = "{}";
          keyboard-name = "at-translated-set-2-keyboard";
        };
      };
    };
    style = ''
      @import "frappe.css";
        * {
          font-family: "FiraCode Nerd Font";
          font-size: 14px;
          min-height: 0px;
          border-radius: 0;
        }

        window#waybar {
          background: transparent;
          color: @text;
        }

        tooltip {
          background: @overlay0;
          border-radius: 10px;
        }

        #workspaces button {
          padding: 0 5px;
          color: @text;
          border-radius: 10px;
        }

        #workspaces button:hover {
          background: @surface1;
        }

        #workspaces button.active {
          background: @surface0;
        }

        #workspaces button.urgent {
          background: @peach;
        }

        #clock,
        #battery,
        #backlight,
        #pulseaudio,
        #tray,
        #custom-notification,
        #language,
        #window {
          padding: 0 10px;
          color: @text;
          border-radius: 10px;
        }

        #window {
          background: @surface0;
        }

        .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
        }

        .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
        }

        #clock {
          background: @surface0;
        }

        #battery {
          background: @surface0;
          color: @text;
        }

        #battery.charging, #battery.plugged {
          color: @text;
          background: @green;
        }

        @keyframes blink {
          to {
            background: #ffffff;
            color: #000000;
          }
        }

        #battery.critical:not(.charging) {
          background: @maroon;
          color: @text;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        label:focus {
          background: #000000;
        }

        #backlight {
          background: @surface0;
        }

        #pulseaudio {
          background: @surface0;
          color: @text;
        }

        #pulseaudio.muted {
          background: @peach;
          color: @text;
        }

        #tray {
          background: @surface0;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background: @peach;
        }

        #language {
          background: @surface0;
          color: @text;
        }
    '';
  };
}
