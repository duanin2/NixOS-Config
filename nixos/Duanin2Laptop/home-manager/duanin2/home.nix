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

      # Inkscape
      inkscape-with-extensions

      # Web Browser
      nyxt
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
    package = inputs.hyprland.packages.x86_64-linux.hyprland.override { inherit (pkgs.new) wayland wayland-scanner wayland-protocols; };
    
    xwayland.enable = true;
    enableNvidiaPatches = true;

    systemdIntegration = true;
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
  };

  services = {
    syncthing = {
      enable = true;
    };
    xsettingsd = {
      enable = true;

      settings = {
        "Net/ThemeName" = config.gtk.theme.name;
        "Gtk/CursorThemeName" = config.gtk.cursorTheme.name;
        "Gtk/CursorThemeSize" = config.gtk.cursorTheme.size;
        "Gtk/FontName" = "${config.gtk.font.name} ${toString config.gtk.font.size}";
        "Net/IconThemeName" = config.gtk.iconTheme.name;
        "Gtk/DecorationLayout" = ":";
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
