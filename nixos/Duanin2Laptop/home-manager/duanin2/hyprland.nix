{ config, pkgs, ... }: let
  mod = "SUPER";
  
  term = "${pkgs.alacritty}/bin/alacritty";
in ''
monitor = eDP-1,1920x1080@60,0x0,1


# Environment
# Toolkit backend
env GDK_BACKEND,wayland,x11
env QT_QPA_PLATFORM,wayland;xcb
env SDL_VIDEODRIVER,wayland
env CLUTTER_BACKEND,wayland

# XDG
env XDG_CURRENT_DESKTOP,Hyprland
env XDG_SESSION_TYPE,wayland
env XDG_SESSION_DESKTOP,Hyprland

# Qt
env QT_AUTO_SCREEN_SCALE_FACTOR,1
env QT_WAYLAND_DISABLE_WINDOWDECORATION,1


# Autostart
exec-once = hyprctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}

exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 # polkit agent

exec-once = eww open bar

exec-once = sleep 1; ${pkgs.networkmanagerapplet}/bin/nm-applet # network manager
exec-once = sleep 1; blueman-applet # bluetooth
exec-once = sleep 1; keepassxc
exec-once = sleep 1; steam -console -nofriendsui -silent -no-browser


windowrulev2 = fullscreen,class:^((stormworks64)\.exe|())$

input {
  kb_layout = cz
  kb_model = acer_laptop

  follow_mouse = 0

  touchpad {
    natural_scroll = false
  }

  sensitivity = 0
}

general {
  gaps_in = 4
  gaps_out = 8
  border_size = 2
  col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
  col.inactive_border = rgba(595959aa)

  layout = dwindle
}
decoration {
  rounding = 12
  blur {
    enabled = true
    size = 3
    passes = 2
    new_optimizations = true
  }

  drop_shadow = true
  shadow_range = 4
  shadow_render_power = 3
  col.shadow = rgba(1a1a1aee)
}
animations {
  enabled = true

  bezier = myBezier, 0.5, -0.2, 0.5, 1.2

  animation = windows, 1, 7, myBezier
  animation = windowsOut, 1, 7, myBezier, popin 80%
  animation = border, 1, 10, myBezier
  animation = borderangle, 1, 8, myBezier
  animation = fade, 1, 7, myBezier
  animation = workspaces, 1, 6, myBezier
}

dwindle {
  pseudotile true
  preserve_split true
}
master {
  new_is_master = true
}

gestures {
  workspace_swipe = false
}

bind = ${mod}, Q, exec, ${term}
bind = ${mod}, C, killactive,
bind = ${mod}, H, movetoworkspacesilent, special
bind = ${mod}, S, togglespecialworkspace
bind = ${mod}, M, exit,
bind = ${mod}, V, togglefloating,
bind = ${mod}, R, exec, true # TODO: Add a system menu
bind = ${mod}, P, pseudo, # dwindle
bind = ${mod}, J, togglesplit, #dwindle

# Focus movement with arrow keys
bind = ${mod}, left, movefocus, l
bind = ${mod}, right, movefocus, r
bind = ${mod}, up, movefocus, u
bind = ${mod}, down, movefocus, d

# Workspace movement using number keys
bind = ${mod}, plus, workspace, 1
bind = ${mod}, ecaron, workspace, 2
bind = ${mod}, scaron, workspace, 3
bind = ${mod}, ccaron, workspace, 4
bind = ${mod}, rcaron, workspace, 5
bind = ${mod}, zcaron, workspace, 6
bind = ${mod}, yacute, workspace, 7
bind = ${mod}, aacute, workspace, 8
bind = ${mod}, iacute, workspace, 9
bind = ${mod}, eacute, workspace, 10
# Workspace movement using scroll wheel
bind = ${mod}, mouse_down, workspace, e+1
bind = ${mod}, mouse_up, workspace, e-1

# Workspace window movement using SHIFT and number keys
bind = ${mod} SHIFT, 1, movetoworkspace, 1
bind = ${mod} SHIFT, 2, movetoworkspace, 2
bind = ${mod} SHIFT, 3, movetoworkspace, 3
bind = ${mod} SHIFT, 4, movetoworkspace, 4
bind = ${mod} SHIFT, 5, movetoworkspace, 5
bind = ${mod} SHIFT, 6, movetoworkspace, 6
bind = ${mod} SHIFT, 7, movetoworkspace, 7
bind = ${mod} SHIFT, 8, movetoworkspace, 8
bind = ${mod} SHIFT, 9, movetoworkspace, 9
bind = ${mod} SHIFT, 0, movetoworkspace, 10

# Window operations using mouse buttons
bindm = ${mod}, mouse:272, movewindow
bindm = ${mod}, mouse:273, resizewindow
''
