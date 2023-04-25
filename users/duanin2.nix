{outputs, config, ...}: {
  imports = [
    ./features/desktop/hyprland
    ./features/games
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  home = {
    username = "duanin2";
    homeDirectory = "/home/${config.home.username}";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
