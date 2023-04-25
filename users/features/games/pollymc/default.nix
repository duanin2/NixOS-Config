{ inputs, ... }: let
  pollymc-pkgs = inputs.pollymc.packages.x86_64-linux;
in {
  home.packages = with pollymc-pkgs; [
    prismlauncher-qt5
  ];
}