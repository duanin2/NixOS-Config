{ pkgs, inputs, nur, ... }: let
  emacsPackage = pkgs.emacs-pgtk;
in {
  imports = [
    nur.repos.rycee.hmModules.emacs-init
  ];
  nixpkgs.overlays = [ inputs.emacs.overlays.default ];

  services.emacs = {
    enable = true;
    package = emacsPackage;

    socketActivation.enable = true;
    client = {
      enable = true;

      arguments = [
        "-r"
        "-n"
      ];
    };
    defaultEditor = true;
  };

  programs.emacs = {
    enable = true;
    package = emacsPackage;

    init = {
      enable = true;

      recommendedGcSettings = true;
    };
  };
}