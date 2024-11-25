{ lib, pkgs, ... }: let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "konsole";
    rev = "3b64040e3f4ae5afb2347e7be8a38bc3cd8c73a8";
    hash = "sha256-d5+ygDrNl2qBxZ5Cn4U7d836+ZHz77m6/yxTIANd9BU=";
  };
in {
  programs.konsole = {
    enable = true;

    customColorSchemes = {
      catppuccinLatte = catppuccin + /themes/catppuccin-latte.colorscheme;
      catppuccinFrappe = catppuccin + /themes/catppuccin-frappe.colorscheme;
      catppuccinMacchiato = catppuccin + /themes/catppuccin-macchiato.colorscheme;
      catppuccinMocha = catppuccin + /themes/catppuccin-mocha.colorscheme;
    };
    defaultProfile = "Default";
    profiles = {
      Default = {
        colorScheme = "catppuccinFrappe";
        command = "${lib.getExe pkgs.nushell}";
      };
      "Raspberry Pi 5" = {
        colorScheme = "catppuccinFrappe";
        command = "${lib.getExe pkgs.openssh} RPi5";
      };
    };
  };
}
