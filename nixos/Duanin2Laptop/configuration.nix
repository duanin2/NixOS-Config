# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, pkgs, chaotic, inputs, outputs, ... }:
let
  swayGreetd = pkgs.writeText "sway-greetd-config" ''
exec "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway; systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr; systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr"
exec "${config.programs.regreet.package}/bin/regreet; swaymsg exit"
include ${pkgs.sway}/etc/sway/config.d/*
  '';
in {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      # Overlays from this flake
      outputs.overlays.additions
      outputs.overlays.modifications

      # Emacs
      inputs.emacs.overlays.default

      # Eww systray
      inputs.rust-overlay.overlays.default
      inputs.eww.overlays.default
    ];
    # nixpkgs configuration
    config = {
      # Allow unfree packages
      allowUnfree = true;
    };
  };

  age = {
    identityPaths = [
      "/persist/system/root/.ssh/id_ed25519"
      "/persist/system/root/.ssh/id_rsa"
      "/persist/system/etc/ssh/ssh_host_ed25519_key"
      "/persist/system/etc/ssh/ssh_host_rsa_key"
    ];
    secrets = {
      duanin2Password.file = ../../secrets/Duanin2Laptop/duanin2/password.age;
      # cryptKey = {
        # file = ../secrets/Duanin2Laptop/cryptkey.age;

        # owner = "root";
        # group = "root";
        # mode = "600";

        # symlink = false;
      # };
    };
  };

  # Impermanence
  environment.persistence."/persist/system" = {
    directories = [
      "/etc/NetworkManager/system-connections" # NetworkManager stuff
      "/etc/ssh" # SSH config
  
      "/var/log" # Logs
      "/var/lib"

      # Waydroid
      "/home/.waydroid"

      # Nix
      "/root/.cache/nix"
    ];
    files = [
      "/etc/machine-id" # For normal functioning of "/var/log"
      "/etc/id-rsa"
      "/crypto_keyfile.bin"
    ];
  };

  catppuccin = {
    # enable = true; # Global enable isn't yet implemented
    
    flavour = "frappe";
  };

  # Use the grub EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = false;
      grub = {
        # Enable GRUB
        enable = true;

        # Enable support for encrypted disk
        enableCryptodisk = true;
        device = "nodev";

        # EFI Support
        efiSupport = true;

        # TODO: Find a way to load EFI variables set by Linux on my laptop
        efiInstallAsRemovable = true;

        # MemTest86
        memtest86.enable = true;

        # Don't copy the kernels
        copyKernels = false;
        storePath = "/@persist/nix/store";

        catppuccin.enable = true;
      };
      efi = {
        efiSysMountPoint = "/boot/efi";

        # TODO: Change to true, once `boot.loader.grub.efiInstallAsRemovable = true;` is no longer needed on my laptop
        canTouchEfiVariables = false;
      };
    };
    initrd = {
      luks.devices = {
        "cryptroot" = {
          device = "/dev/disk/by-uuid/a6e481ff-8174-4fb1-a328-162377bb71d1"; # Device

          # Setup
          preLVM = true;
          keyFile = "/crypto_keyfile.bin";
          fallbackToPassword = true;

          # SSD performance
          bypassWorkqueues = true;
          allowDiscards = true;
        };
      };
      secrets."/crypto_keyfile.bin" = null;

      kernelModules = [ "nouveau" ];
    };

    kernel.sysctl = {
      "kernel.nmi_watchdog" = 0;
    };

    # Use kernel
    kernelPackages = pkgs.linuxPackages_cachyos;
  };

  services.udev = {
    enable = true;

    extraRules = ''
# blacklist for usb autosuspend
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"

ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05c6", ATTR{idProduct}=="9205", ATTR{power/autosuspend}="-1"
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0458", ATTR{idProduct}=="0186", ATTR{power/autosuspend}="-1"
    '';
  };

  zramSwap = {
    enable = true;
    priority = 32767;
    memoryPercent = 95;
    algorithm = "zstd";
  };

  virtualisation = {
    libvirtd = {
      enable = true;

      onShutdown = "shutdown";
      onBoot = "ignore";
      parallelShutdown = 4;

      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
          packages = with pkgs; [
            OVMFFull.fd
          ];
        };
        swtpm = {
          enable = true;
          package = pkgs.swtpm-tpm2;
        };

        runAsRoot = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs = {
    # GnuPG
    gnupg = {
      agent.enable = true;
    };

    # Set up java
    java = {
      enable = true;
      binfmt = true;
      package = pkgs.jdk19;
    };

    # ZSH
    zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      autosuggestions = {
        enable = true;
        async = true;
      };

      syntaxHighlighting.enable = true;

      interactiveShellInit = ''
function launchbg() {
  ${pkgs.bash}/bin/bash -c "exec $1&"&>/dev/null
}
      '';

      # History settings
      histFile = "$HOME/.zsh_history";
      histSize = 100000;
    };

    # Steam
    steam = {
      enable = true;
      package = (pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          glxinfo
          config.hardware.opengl.package
          config.hardware.opengl.package32
          
          config.programs.gamescope.package
          vkbasalt
          mangohud_git
          mangohud32_git
	        gamemode
        ];
        extraEnv = {
          MANGOHUD = "1";
          DRI_PRIME = "1";
        };
        #withJava = true;
      });

      # Steam gamescope session
      gamescopeSession = {
        enable = true;
      };

      # Firewall
      remotePlay.openFirewall = true;
    };
    gamescope = {
      enable = true;
      package = pkgs.gamescope_git;
      capSysNice = true;
    };
    fuse = {
      userAllowOther = true;
      mountMax = 32767;
    };
    nix-ld.enable = true;
    adb.enable = true;
  };

  chaotic.steam.extraCompatPackages = with pkgs; [
    luxtorpeda
    proton-ge-custom
  ];

  chaotic.mesa-git = {
    enable = true;

    extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
      intel-media-driver
    ];
    extraPackages32 = [ ];
  };

  services.udisks2.enable = true;

  networking.hostName = "Duanin2Laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true;

    wifi = {
      scanRandMacAddress = true;
      macAddress = "random";

      powersave = true;
    };
    ethernet.macAddress = "random";

    # Disable Wake-On-LAN
    connectionConfig = {
      "ethernet.wake-on-lan" = "ignore";
      "wifi.wake-on-lan" = "ignore";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Setup NTP
  services.chrony = {
    enable = true;
    serverOption = "offline";
  };
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeScript "10-chrony" ''
#!/bin/sh

INTERFACE=$1
STATUS=$2

# Make sure we're always getting the standard response strings
LANG='C'

chrony_cmd() {
  echo "Chrony going $1."
  exec ${pkgs.chrony}/bin/chronyc -a $1
}

nm_connected() {
  [ "$(${pkgs.networkmanager}/bin/nmcli -t --fields STATE g)" = 'connected' ]
}

case "$STATUS" in
  up)
    chrony_cmd online
  ;;
  vpn-up)
    chrony_cmd online
  ;;
  down)
    # Check for active interface, take offline if none is active
    nm_connected || chrony_cmd offline
  ;;
  vpn-down)
    # Check for active interface, take offline if none is active
    nm_connected || chrony_cmd offline
  ;;
esac
      '';
    }
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    8888
  ];
  # networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "cs_CZ.UTF-8";
  console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = lib.mkForce "cz-qwertz";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable Hyprland Wayland compositor
  programs.hyprland = {
    enable = true;
    package = (inputs.hyprland.packages.x86_64-linux.hyprland.override (old: let
      mesa = config.hardware.opengl.package;
    in {
      inherit mesa;
      wlroots = old.wlroots.override { inherit mesa; };
    }));

    xwayland.enable = true;
    enableNvidiaPatches = true;
  };
  
# Flatpak
  xdg.portal = {
    enable = true;
    extraPortals = [ ];
  };

  # Greetd
  services.greetd = {
    enable = true;
    restart = true;

    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --unsupported-gpu --config ${swayGreetd}";
        user = "greeter";
      };
    };
  };
  programs.regreet = {
    enable = true;
    package = pkgs.greetd.regreet;
  };

  # Configure keymap in X11
  services.xserver.layout = "cz";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;

    # audio servers support
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;

    # Set up
    wireplumber.enable = true;
  };

  # libinput
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.duanin2 = {
      isNormalUser = true;
      extraGroups = [ "wheel" "network" "adbusers" ];
      hashedPassword = (builtins.readFile config.age.secrets.duanin2Password.path);
    };
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    inputs.agenix.packages.${pkgs.system}.default
    (pkgs.uutils-coreutils.override {prefix = "";})
    seatd
    vulkan-tools
    glxinfo
    bc
    fd
    file
    neofetch
    htop
    acpi

    win-virtio
    virt-manager
  ];

  services.openssh = {
    enable = true;

    startWhenNeeded = false;
    settings = {
      X11Forwarding = false;
      UseDns = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  security.polkit = {
    enable = true;

    adminIdentities = [
      "unix-user:wheel"
    ];
    extraConfig = ''
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("network") || subject.local) {
    return polkit.Result.YES;
  }
});
    '';
  };

  system = {
    stateVersion = "23.11";
  };
}
