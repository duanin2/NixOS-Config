{ hyprland, hyprland-plugins, hyprpaper, hyprpicker, hypridle, hyprlock }: { ... }: {
  xdg.configFile."hypr/hyprlock.conf" = {
    enable = true;

    text = ''
    general {
      hide_cursor = false;
      grace = 10;
    }

    background {
      monitor =
      color = rgb(48, 52, 70)
    }

    input-field {
      monitor = eDP-1
      size = 200, 60
      inner_color = rgb(65, 69, 89)
      outer_color = rgb(115, 121, 148)
      font_color = rgb(198, 208, 245)
      numlock_color = rgb(231, 130, 132)
      capslock_color = rgb(166, 209, 137)
      bothlock_color = rgb(229, 200, 144)
      invert_numlock = true
      placeholder_text = <i>Password...</i>
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
      hide_input = true

      position = 0, 20
      halign = center
      valign = center
    }

    label {
      monitor = eDP-1
      test = $USER
      color = rgb(198, 208, 245)
      font_size = 20
      font_family = FiraCode Nerd Font Mono

      position = 0, -20
      halign = center
      valign = center
    }
    '';
  };
}