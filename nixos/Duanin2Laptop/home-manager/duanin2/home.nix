# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, chaotic, pkgs, ... }: let
  extraArgs = { inherit config pkgs; };
in {
  imports = [
    ./emacs.nix
    ./theme.nix
    ./eww
    ./firefox.nix
    ./thunderbird.nix
  ];

  home = {
    username = "duanin2";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.05";

    persistence."/persist/user/${config.home.username}" = {
      directories = [ ];
      files = [ ];
      allowOther = true;
    };

    packages = with pkgs; [
      keepassxc
      git-credential-keepassxc

      # Gaming
      prismlauncher
      vkbasalt
      replay-sorcery
      gamemode
      goverlay
      mangohud_git

      (pkgs.bottles.override {
        extraPkgs = pkgs: with pkgs; [
          gamescope_git
          vkbasalt
	        mangohud_git
          mangohud32_git
          gamemode
	        steam

          xterm
        ];	
      })
      qbittorrent

      lxqt.lxqt-archiver
      arj
      cabextract
      cpio
      lzham
      lha
      rar
      rpmextract
      gzip
      bzip2
      pbzip2
      lrzip
      lzip
      lzop
      xz
      zip
      unzip
      lxqt.pcmanfm-qt
      qt5.qtsvg
      qt6.qtsvg

      # Inkscape
      inkscape-with-extensions

      # Discord
      webcord

      aria2

      (import inputs.nur { inherit pkgs; }).repos.mikaelfangel-nur.spacedrive
    ];
  };

  services.udiskie = {
    enable = true;
    automount = true;
  };

  # Enable Hyprland Wayland compositor
  wayland.windowManager.hyprland = let
    extraConfig = (import ./hyprland.nix) extraArgs;
  in {
    inherit extraConfig;

    enable = true;
    package = inputs.hyprland.packages.x86_64-linux.hyprland;
    
    xwayland.enable = true;
    enableNvidiaPatches = true;

    systemd.enable = true;
  };

  # Enable home-manager and git
  programs = let
    alacritty = (import ./alacritty.nix) extraArgs;
    gpg = (import ./gpg.nix) extraArgs;
    git = (import ./git.nix) extraArgs;
    ssh = import ./ssh.nix;
    zsh = (import ./zsh.nix) extraArgs;
  in {
    inherit alacritty gpg git ssh zsh;
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  services = {
    syncthing = {
      enable = true;
    };
    xsettingsd = {
      enable = true;
      package = pkgs.xsettingsd;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
