# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, chaotic, pkgs, ... }: let
  nix-colors = inputs.nix-colors;
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in {
  imports = [
    ./emacs.nix
    ./gtk.nix
  ];

  nixpkgs = {
    overlays = [
      # Overlays from this flake
      outputs.overlays.additions
      outputs.overlays.modifications

      # Mozilla packages
      inputs.mozilla.overlay

      # Emacs
      inputs.emacs.overlays.default
    ];
    # Nixpkgs config
    config = {
      # Unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  chaotic.nyx = {
    cache.enable = true;
    overlay = {
      enable = true;
      flakeNixpkgs.config = config.nixpkgs.config;
      onTopOf = "flake-nixpkgs";
    };
  };

  nix = {
    package = pkgs.nixVersions.unstable;
    
    checkConfig = true;
  };

  home = {
    username = "duanin2";
    homeDirectory = "/home/duanin2";
    stateVersion = "23.05";

    packages = with pkgs; [
      keepassxc
      git-credential-keepassxc

      # Gaming
      prismlauncher
      vkbasalt
      replay-sorcery
      gamemode
      the-powder-toy

      # Ricing
      (pkgs.eww-systray.override {
        withWayland = true;
      })

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
    extraConfig = (import ./hyprland.nix) { inherit pkgs; };
  in {
    inherit extraConfig;

    enable = true;
    
    xwayland.enable = true;
    enableNvidiaPatches = true;

    systemdIntegration = true;
    recommendedEnvironment = true;
  };

  # Enable home-manager and git
  programs = let
    alacritty = (import ./alacritty.nix) { inherit config pkgs; };
    gpg = (import ./gpg.nix) { inherit config; };
    git = (import ./git.nix) { inherit pkgs; };
    mangohud = (import ./mangohud.nix) { inherit pkgs; };
    ssh = import ./ssh.nix;
    zsh = (import ./zsh.nix) { inherit config; };
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
