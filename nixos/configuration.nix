# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, chaotic, inputs, outputs, ... }:
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
      #outputs.overlays.mesa

      # Emacs
      inputs.emacs.overlays.default

      # Firefox
      inputs.mozilla.overlays.firefox

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
      "/root/.ssh/id_ed25519"
      "/root/.ssh/id_rsa"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key"
      "/persist/system/etc/ssh/ssh_host_ed25519_key"
      "/persist/system/etc/ssh/ssh_host_rsa_key"
    ];
    secrets = {
      duanin2Password.file = ../secrets/Duanin2Laptop/duanin2/password.age;
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

        # Theme
        theme = "${(pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "grub";
          rev = "main";
          hash = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
        })}/src/catppuccin-frappe-grub-theme";
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
    };

    kernel.sysctl = {
      "kernel.nmi_watchdog" = 0;
    };

    # Use CachyOS kernel from Chaotic's Nyx flake
    kernelPackages = pkgs.linuxPackages_zen;
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
          mesa
          
          config.packages.gamescope.package
          vkbasalt
          mangohud_git
          mangohud32_git
	        gamemode
        ];
        extraEnv = {
          MANGOHUD = "1";
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __VK_LAYER_NV_optimus = "NVIDIA_only";
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
      env = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
    fuse = {
      userAllowOther = true;
      mountMax = 32767;
    };
  };

  #chaotic.steam.extraCompatPackages = with pkgs; [
    #luxtorpeda
    #proton-ge-custom
  #];

  # Waydroid
  virtualisation = {
    waydroid.enable = true;
    lxd = {
      enable = true;
      recommendedSysctlSettings = true;
    };
  };

  hardware = {
    opengl = {
      enable = true;

      driSupport = true;
      driSupport32Bit = true;

      extraPackages = (with pkgs; [])
                      ++ (with pkgs.mesa; []);
      extraPackages32 = (with pkgs.pkgsi686Linux; [])
                        ++ (with pkgs.pkgsi686Linux.mesa; []);
    };
    nvidia = {
      # Needed for most wayland compositors
      modesetting.enable = true;

      # My laptop's discrete GPU isn't supported by nvidia-open
      open = false;

      # Disable nvidia settings, since they rely on an Xorg extension and I use wayland
      nvidiaSettings = false;

      # Use the nvidia drivers for the current kernel
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      # Setup PRIME offloading
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Use nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];

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
    package = inputs.hyprland.packages.x86_64-linux.hyprland.override { inherit (pkgs) mesa; };

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
      extraGroups = [ "wheel" "network" ];
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
    home-manager
    inputs.agenix.packages.${pkgs.system}.default
    (pkgs.uutils-coreutils.override {prefix = "";})
    seatd
    vulkan-tools
    glxinfo
    bc
    file

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
