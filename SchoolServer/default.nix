{ config, ... }: {
  import = [
    ./modules/nix
  ];

  home = {
    username = "tilldu22";
    homeDirectory = "/home/${config.home.username}";
  };

  programs.home-manager.enable = true; # install Home Manager

  home.stateVersion = "24.01";
}