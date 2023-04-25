{ inputs, ... }: {
  home.packages = [ inputs.hyprpaper.packages.x86_64-linux.hyprpaper ];
}