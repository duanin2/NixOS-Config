{ pkgs, inputs, ... }: {
  nixpkgs.overlays = [ inputs.emacs.overlays.default ];

  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;

    startWithGraphical = true;
    install = true;
    defaultEditor = true;
  };
}