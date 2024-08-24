{ lib, pkgs, ... }: let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "konsole";
    rev = "3b64040e3f4ae5afb2347e7be8a38bc3cd8c73a8";
    hash = "";
  };
in {
  programs.konsole = {
    enable = true;

    customColorSchemes = {
      catppuccinLatte = catppuccin + /theme/catppuccin-latte.colorscheme;
      catppuccinFrappe = catppuccin + /theme/catppuccin-frappe.colorscheme;
      catppuccinMacchiato = catppuccin + /theme/catppuccin-macchiato.colorscheme;
      catppuccinMocha = catppuccin + /theme/catppuccin-mocha.colorscheme;
    };
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
