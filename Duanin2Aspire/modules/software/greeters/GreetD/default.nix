{ inputs, config, lib, pkgs, ... }: let
  hyprlandConfig = pkgs.writeText "greetd-hyprland.conf" ''
  general {
    border_size = 0
    gaps_in = 0
    gaps_out = 0
  }

  animations {
    enabled = false
    first_launch_animation = false
  }

  input {
    kb_model = acer_laptop
    kb_layout = cz
    numlock_by_default = true
  }

  misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    force_default_wallpaper = 0

    mouse_move_enables_dpms = true
    key_press_enables_dpms = true

    disable_autoreload = true
  }

  env = HYPRCURSOR_THEME, Catppuccin-Frappe-Green-Hyprcursors
  env = HYPRCURSOR_SIZE, 24

  exec-once = ${pkgs.dbus}/bin/dbus-run-session ${lib.getExe config.programs.regreet.package}

  monitor = eDP-1, 1920x1080@60, 0x0, 1
  '';
in {
  imports = [
    ./greeter/regreet.nix
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../../../../../packages/hyprcursor-catppuccin.nix {
      hyprcursor = inputs.hyprland.inputs.hyprcursor.packages.${pkgs.system}.hyprcursor;
    }).frappeGreen
  ];

  services.greetd = {
    enable = true;

    vt = 7;
    settings = {
      default_session = {
        command = "${config.programs.hyprland.finalPackage}/bin/Hyprland --config ${hyprlandConfig}";
      };
    };
  };
}