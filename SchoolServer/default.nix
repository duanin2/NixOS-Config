{ config, ... }: {
  imports = [
    ./modules/nix
  ];

  home = {
    username = "tilldu22";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "24.01";
  };

  programs.home-manager.enable = true; # install Home Manager
}