{ lib, pkgs, ... }: {
  wayland.windowManager.hyprland.settings.exec = [ "pkill mpris-notifier; ${lib.getExe pkgs.mpris-notifier}" ];
}