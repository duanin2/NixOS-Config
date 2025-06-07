{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings.exec = [ "pkill mpris-notifier; mpris-notifier" ];
}