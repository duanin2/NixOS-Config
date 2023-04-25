# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    input type:keyboard {
      xkb_layout cz,cz
      xkb_variant ,rus
      xkb_model acer_laptop
      xkb_options grp:caps_toggle,numpad:mac,shift:both_capslock
    }

    input type:touchpad {
      natural_scroll disabled
    }

    exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c sway; swaymsg exit"

    bindsym Mod4+m exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
  '';
in {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # NixOS Hardware
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    inputs.impermanence.nixosModule

    ./../features/desktop/hyprland
    ./../features/hardware/cpu/intel
    ./../features/hardware/gpu/intel
    ./../features/hardware/gpu/nvidia
    ./../features/services/light

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # timezone
  time.timeZone = "Europe/Prague";

  # OneDrive
  services.onedrive.enable = true;

  networking.hostName = "Duanin2Laptop";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.luks.devices = {
    "cryptroot".preLVM = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  security.pam.services.gtklock = {};

  # users.mutableUsers = false;
  users.users = {
    duanin2 = {
      initialPassword = "ChangeMe";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ ];
      extraGroups = [ "wheel" "video" "input" "networkmanager" "libvirtd" ];
      shell = pkgs.zsh;
    };
  };
  users.defaultUserShell = pkgs.zsh;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = false;
    # Forbid root login through SSH.
    permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = false;
  };

  hardware.opentabletdriver.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
  environment.systemPackages = with pkgs; [
    wofi
    vscodium
    xdg-utils
    #networkmanagerapplet
    libsForQt5.qtstyleplugin-kvantum
    virt-manager-qt
    keepassxc
    libsForQt5.ark
    appimage-run
    discord
    direnv
    nil
    jq
  ];

  # Virt-Manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  fonts.fonts = with pkgs; [
    font-awesome
    firacode-nerdfont
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  services.flatpak.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${swayConfig} --unsupported-gpu";
        user = "greeter";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    Hyprland
    zsh
  '';

  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 49000; to = 65535; }
    ];
    allowedUDPPortRanges = [
      { from = 49000; to = 65535; }
    ];
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/adjtime"
      "/etc/NIXOS"
      "/etc/machine-id"
      "/etc/nixos"
      "/var/lib/flatpak"
    ];
    files = [
      "/var/lib/NetworkManager/secret_key"
      "/var/lib/NetworkManager/seen-bssids"
      "/var/lib/NetworkManager/timestamps"
    ];
  };
}
