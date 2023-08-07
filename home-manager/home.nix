# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: let
  nix-colors = inputs.nix-colors;
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in {
  imports = [
    ./emacs.nix
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

  nix = {
    package = pkgs.nixVersions.unstable;
    
    checkConfig = true;
    settings = {
      use-xdg-base-directories = true;
    };
  };

  home = {
    username = "duanin2";
    homeDirectory = "/home/duanin2";
    stateVersion = "23.11";

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
      (pkgs.eww.override {
        withWayland = true;
      })

      (pkgs.bottles.override {
        extraPkgs = pkgs: with pkgs; [
          gamescope
          vkbasalt
	        mangohud
          gamemode
	        steam

          xterm

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

      libsForQt5.ark
      pcmanfm-qt
    ];
  };

  services.udiskie = {
    enable = true;
    automount = true;
  };

  # Color scheme
  colorScheme = nix-colors.colorSchemes.catppuccin-frappe;

  # Enable Hyprland Wayland compositor
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    enableNvidiaPatches = true;

    systemdIntegration = true;
    settings = {
      monitor = [
        "eDP-1,1920x1080@60,0x0,1"
      ];

      env = [
        "XCURSOR_SIZE,18"
      ];

      exec = [ ];
      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];

      input = {
        kb_layout = "cz";
        kb_model = "acer_laptop";

        follow_mouse = 0;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
      };
      decoration = {
        rounding = 12;
        blur = true;
        blur_size = 3;
        blur_passes = 2;
        blur_new_optimizations = true;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      animations = {
        enabled = true;

        bezier = "myBezier, 0.5, -0.2, 0.5, 1.2";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, myBezier, popin 80%"
          "border, 1, 10, myBezier"
          "borderangle, 1, 8, myBezier"
          "fade, 1, 7, myBezier"
          "workspaces, 1, 6, myBezier"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_is_master = true;
      };

      gestures = {
        workspace_swipe = false;
      };

      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, ${pkgs.alacritty}/bin/alacritty"
        "$mod, C, killactive,"
        "$mod, H, movetoworkspacesilent, special"
        "$mod, S, togglespecialworkspace"
        "$mod, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, R, exec, true" # TODO: Add a system menu
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," #dwindle

        # Focus movement with arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Workspace movement using number keys
        "$mod, plus, workspace, 1"
        "$mod, ecaron, workspace, 2"
        "$mod, scaron, workspace, 3"
        "$mod, ccaron, workspace, 4"
        "$mod, rcaron, workspace, 5"
        "$mod, zcaron, workspace, 6"
        "$mod, yacute, workspace, 7"
        "$mod, aacute, workspace, 8"
        "$mod, iacute, workspace, 9"
        "$mod, eacute, workspace, 10"
        # Workspace movement using scroll wheel
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Workspace window movement using SHIFT and number keys
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];
      bindm = [
        # Window operations using mouse buttons
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Enable home-manager and git
  programs = let
    gpg = (import ./gpg.nix) { inherit config; };
    git = (import ./git.nix) { inherit pkgs; };
    ssh = import ./ssh.nix;
  in {
    inherit gpg git ssh;
    home-manager.enable = true;
    firefox = {
      enable = true;
      package = pkgs.latest.firefox-nightly-bin;
    };
    zsh = {
      enable = true;

      # Configuration
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      defaultKeymap = "emacs";
      initExtra = ''
function launchbg() {
  sh -c "\
  exec $1 &" \
  &> /dev/null
}
'';

      # ZSH history settings
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreSpace = true;
        path = "${config.home.homeDirectory}/.zsh_history";
        save = 100000;
      };
    };
    mangohud = {
      enable = true;

      settings = {
        # Display
        vsync = 0;

        # Basic info
        custom_text_center = "MangoHUD";
        time = true;
        time_format = "%X";

        # GPU
        gpu_temp = true;
        gpu_text = "GPU";
        gpu_load_change = true;
        gpu_load_value = "25,50,75";
        gpu_load_color = "41FC02,ADFC02,FC9002,FC1302";
        throttling_status = true;
        gpu_name = true;

        # CPU
        cpu_temp = true;
        cpu_text = "CPU";
        cpu_mhz = true;
        cpu_load_change = true;
        cpu_load_value = "25,50,75";
        cpu_load_color = "41FC02,ADFC02,FC9002,FC1302";

        # Battery info
        battery = true;
        battery_icon = true;
        battery_time = true;

        # FPS
        fps = true;
        fps_color_change = true;
        fps_value = "30,60";
        fps_color = "FC0202,FCFC02,23FC02";
        frametime = true;
        frame_timing = true;

        # Layout
        position = "top-left";
        round_corners = 6;
      };
    };
    alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 6;
            y = 6;
          };
          opacity = 0.8;
        };
        font = {
          family = "monospace";
          size = 10;
        };
        colors = {
          primary = {
            background = "#${config.colorScheme.colors.base00}";
            foreground = "#${config.colorScheme.colors.base05}";
          };
          cursor = {
            text = "#${config.colorScheme.colors.base00}";
            cursor = "#${config.colorScheme.colors.base05}";
          };
          normal = {
            black = "#${config.colorScheme.colors.base00}";
            red = "#${config.colorScheme.colors.base08}";
            green = "#${config.colorScheme.colors.base0B}";
            yellow = "#${config.colorScheme.colors.base0A}";
            blue = "#${config.colorScheme.colors.base0D}";
            magenta = "#${config.colorScheme.colors.base0E}";
            cyan = "#${config.colorScheme.colors.base0C}";
            white = "#${config.colorScheme.colors.base05}";
          };
          bright = {
            black = "#${config.colorScheme.colors.base03}";
            red = "#${config.colorScheme.colors.base08}";
            green = "#${config.colorScheme.colors.base0B}";
            yellow = "#${config.colorScheme.colors.base0A}";
            blue = "#${config.colorScheme.colors.base0D}";
            magenta = "#${config.colorScheme.colors.base0E}";
            cyan = "#${config.colorScheme.colors.base0C}";
            white = "#${config.colorScheme.colors.base07}";
          };
          indexed_colors = [
            { index = 16; color = "#${config.colorScheme.colors.base09}"; }
            { index = 17; color = "#${config.colorScheme.colors.base0F}"; }
            { index = 18; color = "#${config.colorScheme.colors.base01}"; }
            { index = 19; color = "#${config.colorScheme.colors.base02}"; }
            { index = 20; color = "#${config.colorScheme.colors.base04}"; }
            { index = 21; color = "#${config.colorScheme.colors.base06}"; }
          ];
        };
        cursor = {
          style = {
            shape = "Beam";
            blinking = "Always";
          };
        };
      };
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
