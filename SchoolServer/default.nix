{ config, modules, ... }: {
  imports = [
    (modules.local + /nix)
  ];

  home = {
    username = "tilldu22";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true; # install Home Manager
}
