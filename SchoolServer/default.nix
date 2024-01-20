{ config, ... }: {
  import = [
    ./modules/nix
  ];

  home = {};

  programs.home-manager.enable = true; # install Home Manager
}