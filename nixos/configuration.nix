# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, outputs, ... }:
let
  nixos-update = pkgs.writeShellScriptBin "update" ''
[[ -z $NIX_CONFIG_LOCATION ]] && NIX_CONFIG_LOCATION=/etc/nixos
[[ -z $NIX_CONFIG_HOSTNAME ]] && NIX_CONFIG_HOSTNAME=${config.networking.hostName}
[[ -z $NIX_CONFIG_USER ]] && NIX_CONFIG_USER=$USER

export NIX_CONFIG="experimental-features = nix-command flakes"

isDone=0

sudo -v

{
  while [[ $isDone == 0 ]]; do
    sudo -nv
    ${pkgs.coreutils-full}/bin/sleep 30
  done
} &> /dev/null &

echo "$(${pkgs.ncurses}/bin/tput setaf 10)Staging changes in $NIX_CONFIG_LOCATION$(${pkgs.ncurses}/bin/tput sgr0)"
sudo --preserve-env=NIX_CONFIG -n ${pkgs.bash}/bin/bash -c "cd $NIX_CONFIG_LOCATION; ${pkgs.git}/bin/git add ." || isDone=2

echo "$(${pkgs.ncurses}/bin/tput setaf 10)Updating flake lock for flake $NIX_CONFIG_LOCATION$(${pkgs.ncurses}/bin/tput sgr0)"
sudo --preserve-env=NIX_CONFIG -n ${pkgs.bash}/bin/bash -c "${pkgs.nixStable}/bin/nix flake update --quiet $NIX_CONFIG_LOCATION" || isDone=2

echo "$(${pkgs.ncurses}/bin/tput setaf 10)Rebuilding system from flake $NIX_CONFIG_LOCATION for system $NIX_CONFIG_HOSTNAME$(${pkgs.ncurses}/bin/tput sgr0)"
sudo --preserve-env=NIX_CONFIG -n ${pkgs.bash}/bin/bash -c "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --quiet --impure --flake $NIX_CONFIG_LOCATION#$NIX_CONFIG_HOSTNAME" || isDone=2

echo "$(${pkgs.ncurses}/bin/tput setaf 10)Rebuilding user from flake $NIX_CONFIG_LOCATION for user $NIX_CONFIG_USER@$NIX_CONFIG_HOSTNAME$(${pkgs.ncurses}/bin/tput sgr0)"
${pkgs.home-manager}/bin/home-manager switch --impure --flake "$NIX_CONFIG_LOCATION#$NIX_CONFIG_USER@$NIX_CONFIG_HOSTNAME" || isDone=2

if [[ isDone == 2 ]]; then
  echo "$(${pkgs.ncurses}/bin/tput setaf 9)The update didn't finish successfully$(${pkgs.ncurses}/bin/tput sgr0)"
  exit 1
else
  isDone=1
  echo "$(${pkgs.ncurses}/bin/tput setaf 10)The update finished successfully$(${pkgs.ncurses}/bin/tput sgr0)"
  exit 0
fi
  '';
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
      "/persist/system/etc/ssh/ssh_host_ed25519_key"
      "/persist/system/etc/ssh/ssh_host_rsa_key"
    ];
    secrets = {
      duanin2Password.file = ../secrets/users/duanin2/password.age;
      # cryptKey = {
        # file = ../secrets/Duanin2Laptop/cryptkey.age;

        # owner = "root";
        # group = "root";
        # mode = "600";

        # symlink = false;
      # };
    };
  };

  nix = {
    enable = true; # DO NOT DISABLE
    package = pkgs.nixVersions.unstable;

    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
      accept-flake-config = true;
      builders-use-substitutes = true;
      connect-timeout = 5;
      cores = 4;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      fallback = true;
      http-connections = 0;
      log-lines = 20;
      max-jobs = 1;
      preallocate-contents = true;
      use-xdg-base-directories = true;

      substituters = [
        "hyprland.cachix.org"
        "nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    checkConfig = true;
    checkAllErrors = true;
    channel.enable = false;

    daemonIOSchedPriority = 0;
    daemonIOSchedClass = "best-effort";
    daemonCPUSchedPolicy = "batch";

    gc = {
      randomizedDelaySec = "60min";
      persistent = true;
      dates = "weekly";
      automatic = true;
    };
  };

  programs.direnv = {
    enable = true;
  };

  # Impermanence
  environment.persistence."/persist/system" = {
    directories = [
      "/etc/nixos" # NixOS config
      "/etc/NetworkManager/system-connections" # NetworkManager stuff
      "/etc/ssh" # SSH config
  
      "/var/log" # Logs
      "/var/lib"

      # Waydroid
      "/home/.waydroid"
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

        # FIX: Find a way to load EFI variable set by Linux on my laptop
        efiInstallAsRemovable = true;

        # MemTest86
        memtest86.enable = true;
      };
      efi = {
        efiSysMountPoint = "/boot/efi";

        # FIX: Change to true, once `boot.loader.grub.efiInstallAsRemovable = true;` is no longer needed on my laptop
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

    # Use linux-zen kernel from unstable channel
    kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_zen;
  };

  services.udev = {
    enable = true;

    extraRules = ''
# blacklist for usb autosuspend
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"

ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05c6", ATTR{idProduct}=="9205", ATTR{power/autosuspend}="-1"
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0458", ATTR{idProduct}=="0186", ATTR{power/autosuspend}="10"
    '';
  };

  zramSwap = {
    enable = true;
    priority = 32767;
    memoryPercent = 80;
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
          
          gamescope
          vkbasalt
          mangohud
	        gamemode

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
      package = pkgs.gamescope;
      capSysNice = true;
      env = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
  };

  # Waydroid
  virtualisation = {
    waydroid.enable = true;
    lxd = {
      enable = true;
      recommendedSysctlSettings = true;
    };
  };

  hardware = {
    # enable OpenGL
    opengl = {
      enable = true;
      
      driSupport = true;
      driSupport32Bit = true;

      # Install drivers
      extraPackages = with pkgs; [ ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ ];
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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    nvidiaPatches = true;
  };
  
  # Flatpak
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      # inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland # Hyprland
    ];
    # xdgOpenUsePortals = true;
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
      extraGroups = [ "wheel" "network" ]; # Enable ‘${pkgs.sudo}’ for the user.
      shell = pkgs.zsh;
      passwordFile = config.age.secrets.duanin2Password.path;
    };
    defaultUserShell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    home-manager
    inputs.agenix.packages.${pkgs.system}.default
    nixos-update
    (pkgs.uutils-coreutils.override {prefix = "";})
    seatd
    vulkan-tools
    glxinfo
    bc
    file

    win-virtio
    win-qemu
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
    replaceRuntimeDependencies = [
      # Use newer mesa
      { original = pkgs.mesa; replacement = pkgs.mesa-next; }
      { original = pkgs.mesa.drivers; replacement = pkgs.mesa-next.drivers; }
    ];
  };
}
