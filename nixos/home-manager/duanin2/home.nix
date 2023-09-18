# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, nix-colors, chaotic, pkgs, ... }: let
  extraArgs = { inherit config pkgs; };
  
  nix-colors = inputs.nix-colors;
  nix-colors-lib = nix-colors.lib.contrib { inherit pkgs; };
in {
  imports = [
    ./emacs.nix
    ./gtk.nix
    ./eww
  ];

  home = {
    username = "duanin2";
    homeDirectory = "/home/duanin2";
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

      # Ricing
      eww-wayland

      (pkgs.bottles.override {
        extraPkgs = pkgs: with pkgs; [
          gamescope_git
          vkbasalt
	        mangohud_git
          mangohud32_git
          gamemode
	        steam

          xterm

          # Dependencies
          libgdiplus
	        keyutils
	        libkrb5
	        libpng
	        libpulseaudio
	        libvorbis
	        stdenv.cc.cc.lib
	        xorg.libXcursor
	        xorg.libXi
	        xorg.libXinerama
	        xorg.libXScrnSaver
        ];	
      })
      qbittorrent

      lxqt.lxqt-archiver
      lxqt.pcmanfm-qt
    ];
  };

  services.udiskie = {
    enable = true;
    automount = true;
  };

  # Color scheme
  colorScheme = nix-colors.colorSchemes.catppuccin-frappe;

  # Enable Hyprland Wayland compositor
  wayland.windowManager.hyprland = let
    extraConfig = (import ./hyprland.nix) extraArgs;
  in {
    inherit extraConfig;

    enable = true;
    package = inputs.hyprland.packages.x86_64-linux.hyprland.override { inherit (pkgs) mesa; };
    
    xwayland.enable = true;
    enableNvidiaPatches = true;

    systemdIntegration = true;
  };

  # Enable home-manager and git
  programs = let
    alacritty = (import ./alacritty.nix) extraArgs;
    gpg = (import ./gpg.nix) extraArgs;
    git = (import ./git.nix) extraArgs;
    mangohud = (import ./mangohud.nix) extraArgs;
    ssh = import ./ssh.nix;
    zsh = (import ./zsh.nix) extraArgs;
  in {
    inherit alacritty gpg git mangohud ssh zsh;
    home-manager.enable = true;
    firefox = {
      enable = true;
      package = pkgs.latest.firefox-nightly-bin;
    };
  };

  services = {
    syncthing = {
      enable = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
