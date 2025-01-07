{ pkgs, ... }: let
  variant = "frappe";
in {
  boot.plymouth = {
    enable = true;

    themePackages = with pkgs; [
      # (catppuccin-plymouth.override { inherit variant; })
    ];
    theme = "catppuccin-${variant}";
  };
}