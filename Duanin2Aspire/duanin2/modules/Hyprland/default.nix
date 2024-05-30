{ config, lib, inputs, pkgs, persistDirectory, ... }: let
	hyprland = inputs.hyprland.packages.${pkgs.system};
	hyprland-plugins = inputs.hyprland-plugins.packages.${pkgs.system};
	hyprcursor = inputs.hyprcursor.packages.${pkgs.system};
	hyprpaper = inputs.hyprpaper.packages.${pkgs.system};
	hyprpicker = inputs.hyprpicker.packages.${pkgs.system};
	hypridle = inputs.hypridle.packages.${pkgs.system};
	hyprlock = inputs.hyprlock.packages.${pkgs.system};

  wallpaper = "${inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
    width = 1920;
    height = 1080;
    logoSize = 80;
    preset = "catppuccin-frappe-rainbow";
  }}/share/wallpapers/nixos-wallpaper.png";

	minimize = let
		hyprlandPackage = config.wayland.windowManager.hyprland.package;
	in pkgs.writeTextFile {
		name = "minimize-hyprland.nu";
		executable = true;
		text = ''
#!${lib.getExe pkgs.nushell}

$env.PATH = $env.PATH | prepend "${hyprlandPackage}/bin"

if (hyprctl activewindow -j | from json).workspace.id == -99 {
	hyprctl dispatch movetoworkspacesilent (hyprctl -j activeworkspace | from json).id
} else {
	hyprctl dispatch movetoworkspacesilent special
}
		'';
	};

	mod = "SUPER";
	term = "${lib.getExe pkgs.alacritty}";

  getMods = with lib; mods: (concatedString "_" mods);
	getParams = with lib; params: (concatedString ", " params);

	listToBinds = dispatcher: modKeys: list: map (x: "${getMods modKeys}, ${x.keys}, ${dispatcher}, ${getParams x.params}") list;
	listToWindowrules = window: list: map (rule: "${rule}, ${window}") list;
in {
	imports = let
		configAttrs = { inherit hyprland hyprland-plugins hyprcursor hyprpaper hyprpicker hypridle hyprlock wallpaper; };
	in [
		(import ./hypridle.nix configAttrs)
		(import ./hyprlock.nix configAttrs)
		(import ./hyprcursor.nix configAttrs)
    (import ./hyprpaper.nix configAttrs)
	];

	wayland.windowManager.hyprland = {
		enable = true;
		package = hyprland.hyprland;

		systemd = {
			enable = true;
		};
		xwayland = {
			enable = true;
		};
		plugins = with hyprland-plugins; [
			hyprbars
		];
		settings = {
			monitor = [
				"eDP-1, 1920x1080@60, 0x0, 1"
			];

			# Environment
			env = [
				# Toolkits
				"GDK_BACKEND, wayland,x11" # GTK
				"SDL_VIDEODRIVER, wayland" # SDL
				"CLUTTER_BACKEND, wayland" # Clutter
				"QT_QPA_PLATFORM, wayland;xcb" # Qt
				"QT_AUTO_SCREEN_SCALE_FACTOR, 1"
				"QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"

				# XDG
				"XDG_CURRENT_DESKTOP, Hyprland"
				"XDG_SESSION_DESKTOP, Hyprland"
				"XDG_SESSION_TYPE, wayland"
			];

			# Autostart
			exec-once = [
				"${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
				"${lib.getExe hypridle.hypridle}"
        "${lib.getExe hyprpaper.hyprpaper}"
        "${lib.getExe pkgs.eww}"
			];

			bind = [
				"${mod}, C, killactive,"
				"${mod}, S, togglespecialworkspace"
				"${mod}, M, exit,"
				"${mod}, V, togglefloating,"
				"${mod}, P, pseudo," # dwindle
				"${mod}, J, togglesplit," # dwindle
			] ++ listToBinds "workspace" mod [ # Workspace Control
				{ keys = "plus"; params = "1"; }
				{ keys = "ecaron"; params = "2"; }
				{ keys = "scaron"; params = "3"; }
				{ keys = "ccaron"; params = "4"; }
				{ keys = "rcaron"; params = "5"; }
				{ keys = "zcaron"; params = "6"; }
				{ keys = "yacute"; params = "7"; }
				{ keys = "aacute"; params = "8"; }
				{ keys = "iacute"; params = "9"; }
				{ keys = "eacute"; params = "10"; }
			] ++ listToBinds "workspace" mod [
				{ keys = "mouse_up"; params = "e+1"; }
				{ keys = "mouse_down"; params = "e-1"; }
			] ++ listToBinds "movetoworkspace" mod [
				{ keys = "1"; params = "1"; }
				{ keys = "2"; params = "2"; }
				{ keys = "3"; params = "3"; }
				{ keys = "4"; params = "4"; }
				{ keys = "5"; params = "5"; }
				{ keys = "6"; params = "6"; }
				{ keys = "7"; params = "7"; }
				{ keys = "8"; params = "8"; }
				{ keys = "9"; params = "9"; }
				{ keys = "0"; params = "10"; }
			] ++ listToBinds "movetoworkspace" mod [
				{ keys = "mouse_up"; params = "e+1"; }
				{ keys = "mouse_down"; params = "e-1"; }
			] ++ listToBinds "exec" null (let # Brightness Control
				setBrightness = "${lib.getExe pkgs.brightnessctl} -s set";
			in [
				{ keys = "XF86MonBrightnessUp"; params = "${setBrightness} +5%"; }
				{ keys = "XF86MonBrightnessDown"; params = "${setBrightness} 5%-"; }
			]) ++ listToBinds "exec" null (let # Volume Control
				setVolume = with lib; type: action: "${pkgs.pulseaudio}/bin/pactl set-${
          oneOfOrDefault
            type
            "sink"
            [ "sink" "source" ]
        }-${
          oneOfOrDefault
            action
            "volume"
            [ "volume" "mute" ]
        }";
			in [
				{ keys = "XF86AudioRaiseVolume"; params = "${setVolume "sink" "volume"} @DEFAULT_SINK@ +5%"; }
				{ keys = "XF86AudioLowerVolume"; params = "${setVolume "sink" "volume"} @DEFAULT_SINK@ -5%"; }
				{ keys = "XF86AudioMute"; params = "${setVolume "sink" "mute"} @DEFAULT_SINK@ toggle"; }
			]) ++ listToBinds "exec" mod [ # Execute on bind
				{ keys = "T"; params = term; }
				{ keys = "H"; params = "${minimize}"; }
			] ++ listToBinds "moveFocus" mod [ # Focus movement
				{ keys = "left"; params = "l"; }
				{ keys = "right"; params = "r"; }
				{ keys = "up"; params = "u"; }
				{ keys = "down"; params = "d"; }
			];

			bindm = [
				"${mod}, mouse:272, movewindow"
				"${mod}, mouse:273, resizewindow"
			];

			input = {
				kb_layout = "cz";
				kb_model = "acer_laptop";

				numlock_by_default = true;

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
				"col.active_border" = "$red $green 45deg";
				"col.inactive_border" = "rgba($mantleAlphaaa)";

				resize_on_border = true;

				allow_tearing = true;

				layout = "dwindle";
			};

			decoration = {
				rounding = 12;

				blur = {
					enabled = true;

					size = 3;
					passes = 2;
					new_optimizations = true;
				};

				drop_shadow = true;
				shadow_range = 4;
				shadow_render_power = 3;
				"col.shadow" = "rgba($mantleAlphaee)";
			};

			animations = {
				enabled = true;

				bezier = [
          "overshot, .5, -.1, .5, 1.1"
          "linear, 0, 0, 1, 1"
        ];
        
				animation = [
					"windows, 1, 7, overshot"
					"windowsOut, 1, 7, overshot, popin 80%"
					"border, 1, 10, overshot"
					"borderangle, 1, 50, linear, loop"
					"fade, 1, 7, overshot"
					"workspaces, 1, 6, overshot"
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

			misc = {
				enable_swallow = true;
				swallow_regex = "^Alacritty$";

				mouse_move_enables_dpms = true;
    		key_press_enables_dpms = true;

        new_window_takes_over_fullscreen = 2;
        disable_hyprland_logo = true;

        font_family = config.gtk.font.name;
			};

			windowrulev2 = listToWindowrules "class:polkit-gnome-authentication-agent-1" [
				"float"
				"center"
				"size 654 436"
				"stayfocused"
				"idleinhibit always"
				"dimaround"
				"xray on"
        "noshadow"
        "noborder"
        "forceinput"
        "stayfocused"
        "pin"
        "plugin:hyprbars:nobar"
			] ++ (listToWindowrules "class:firefox,title:About Mozilla Firefox" [
				"float"
				"center"
				"size 654 436"
				"xray on"
        "noshadow"
        "noborder"
			]);
		};

		extraConfig = ''
plugin {
	hyprbars {
		bar_height = 25

		bar_precedence_over_border = true
		bar_part_of_window = true

		bar_text_font = ${config.gtk.font.name}
    bar_text_size = ${toString config.gtk.font.size}

		bar_color = $surface0
		col.text = $text

		hyprbars-button = $red, 15, 󰅖, hyprctl dispatch killactive
		hyprbars-button = $yellow, 15, 󰖯, hyprctl dispatch fullscreen 1
		hyprbars-button = $blue, 15, 󰖰, ${minimize}
	}
}
		'';
	};

	home.persistence.${persistDirectory} = {
    directories = [ ".cache/hyprland" ];
  };
}
