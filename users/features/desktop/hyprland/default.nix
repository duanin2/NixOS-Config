{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./../common
    ./../common/theme.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (import ./config.nix {
      inherit config inputs pkgs;
    });
  };
}
