{ inputs, ... }: {
  imports = [
    inputs.hyprland.nixosModules.default
    ./../../services/pipewire
    ./../../services/pipewire/audio
    ./../../services/polkit
    ./../../services/xdg/desktop-portals
  ];

  nix.settings = {
    # Hyprland Cache
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs.hyprland.enable = true;
}