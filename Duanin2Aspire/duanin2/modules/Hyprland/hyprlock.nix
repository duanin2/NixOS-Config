{ hyprland, hyprland-plugins, hyprpaper, hyprpicker, hypridle, hyprlock }: { config, ... }: let
  colorPalette = config.colorScheme.palette;
in {
  xdg.configFile."hypr/hyprlock.conf" = {
    enable = true;

    text = ''
    general {
      hide_cursor = false;
      grace = 10;
    }

    background {
      monitor =
      color = rgb(${colorPalette.base00})
    }

    input-field {
      monitor = eDP-1
      size = 200, 60
      inner_color = rgb(${colorPalette.base02})
      outer_color = rgb(${colorPalette.base01})
      font_color = rgb(${colorPalette.base05})
      numlock_color = rgb(${colorPalette.base0B})
      capslock_color = rgb(${colorPalette.base08})
      bothlock_color = rgb(${colorPalette.base0A})
      invert_numlock = true
      placeholder_text = <i>Password...</i>
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
      hide_input = true

      position = 0, -30
      halign = center
      valign = center
    }

    label {
      monitor = eDP-1
      text = $USER
      color = rgb(${colorPalette.base05})
      font_size = 20
      font_family = FiraCode Nerd Font Mono

      position = 0, 25
      halign = center
      valign = center
    }
    '';
  };
}