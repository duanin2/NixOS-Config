{ ... }: { inputs, pkgs, ... }: let
  wallpaper = "${inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
    width = 1920;
    height = 1080;
    logoSize = 80;
    preset = "catppuccin-frappe-rainbow";
  }}/share/wallpapers/nixos-wallpaper.png";
in {
  xdg.configFile."hypr/hyprpaper.conf" = {
    enable = true;

    text = ''
    preload = ${wallpaper}

    wallpaper = eDP-1,${wallpaper}

    splash = true
    splash_offset = 10
    '';
  };
}
