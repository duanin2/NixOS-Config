{ inputs, pkgs, ... }: {
  imports = [
    ./cursor.nix
    ./gtk.nix
    ./colors.nix
    # ./qt.nix

    ./catppuccin.nix
  ];

  _module.args.wallpaper = "${inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
    width = 1920;
    height = 1080;
    logoSize = 80;
    preset = "catppuccin-frappe-rainbow";
  }}/share/wallpapers/nixos-wallpaper.png";
}
