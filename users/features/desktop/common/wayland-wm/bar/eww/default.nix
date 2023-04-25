{ pkgs, config, ... }: {
  imports = [
    ../../../../../impermanence
  ];
  programs.eww = {
    enable = true;
    package = with pkgs; eww-wayland;
    configDir = "${config.home.homeDirectory}/.eww";
  };

  home.packages = with pkgs; [
    socat
  ];

  home.persistence."/etc/nixos/users/features/desktop/common/wayland-wm/bar/eww" = {
    files = [ ".config/eww/eww.yuck" ".config/eww/eww.scss" ];
    directories = [ ".config/eww/scripts" ];
  };
}