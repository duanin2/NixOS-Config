{ config, inputs, pkgs, ... }: ''
# XDG variables
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland

# QT variables
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
env = QT_QPA_PLATFORM,wayland;xcb
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = QT_STYLE_OVERRIDE,kvantum

# Toolkit backend variables
env = SDL_VIDEODRIVER,wayland
env = _JAVA_AWT_WM_NONEREPARENTING,1
env = CLUTTER_BACKEND,wayland
env = GDK_BACKEND,wayland,x11

# hyprland fixes
env = WLR_NO_HARDWARE_CURSORS,1

# theming
env = GTK_THEME,${config.gtk.theme.name}
env = XCURSOR_THEME,${config.home.pointerCursor.name}
env = XCURSOR_SIZE,${toString config.home.pointerCursor.size}
exec = hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}

exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

monitor = eDP-1,1920x1080,0x0,1

${if builtins.elem inputs.hyprpaper.packages.x86_64-linux.hyprpaper config.home.packages then "exec-once = ${inputs.hyprpaper.packages.x86_64-linux.hyprpaper}/bin/hyprpaper" else ""}
exec-once = eww daemon && eww open bar
exec-once = foot -s &
exec-once = swaync &
#exec-once = nm-applet --indicator &
exec-once = sleep 5 && keepassxc &
#exec-once = blueman-applet &
exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
exec = swaync-client -R; swaync-client -rs

input {
  kb_layout = cz,cz
  kb_variant = ,rus
  kb_model = acer_laptop
  kb_options = grp:caps_toggle,numpad:mac,shift:both_capslock
  kb_rules =

  numlock_by_default = true

  follow_mouse = 1

  touchpad {
    natural_scroll = false
  }

  sensitivity = 0
}

general {
  gaps_in = 3
  gaps_out = 6
  border_size = 3
  col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
  col.inactive_border = rgba(595959aa)

  layout = dwindle
}

decoration {
  rounding = 6
  blur = true
  blur_size = 3
  blur_passes = 1
  blur_new_optimizations = true

  drop_shadow = true
  shadow_range = 4
  shadow_render_power = 3
  col.shadow = rgba(1a1a1aee)
}

animations {
  enabled = true

  bezier = myBezier, 0.05, 0.9, 0.1, 1.05

  animation = windows, 1, 7, myBezier
  animation = windowsOut, 1, 7, default, popin 80%
  animation = border, 1, 10, default
  #animation = borderangle, 1, 8, default
  animation = fade, 1, 7, default
  animation = workspaces, 1, 6, default
}

dwindle {
  pseudotile = true
  preserve_split = true # you probably want this
}

master {
  new_is_master = true
}

gestures {
  workspace_swipe = false
}

device:epic mouse V1 {
  sensitivity = -0.5
}

$mainMod = SUPER

bind = $mainMod, Q, exec, footclient
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, pcmanfm
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,

bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

bind = $mainMod, SPACE, togglefloating

bind = $mainMod, plus, workspace, 1
bind = $mainMod, ecaron, workspace, 2
bind = $mainMod, scaron, workspace, 3
bind = $mainMod, ccaron, workspace, 4
bind = $mainMod, rcaron, workspace, 5
bind = $mainMod, zcaron, workspace, 6
bind = $mainMod, yacute, workspace, 7
bind = $mainMod, aacute, workspace, 8
bind = $mainMod, iacute, workspace, 9
bind = $mainMod, eacute, workspace, 10

bind = $mainMod SHIFT, plus, movetoworkspace, 1
bind = $mainMod SHIFT, ecaron, movetoworkspace, 2
bind = $mainMod SHIFT, scaron, movetoworkspace, 3
bind = $mainMod SHIFT, ccaron, movetoworkspace, 4
bind = $mainMod SHIFT, rcaron, movetoworkspace, 5
bind = $mainMod SHIFT, zcaron, movetoworkspace, 6
bind = $mainMod SHIFT, yacute, movetoworkspace, 7
bind = $mainMod SHIFT, aacute, movetoworkspace, 8
bind = $mainMod SHIFT, iacute, movetoworkspace, 9
bind = $mainMod SHIFT, eacute, movetoworkspace, 10

bind = $mainMod, H, movetoworkspace, special
bind = $mainMod, S, togglespecialworkspace

bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
''