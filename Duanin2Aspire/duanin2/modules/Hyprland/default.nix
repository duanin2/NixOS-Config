{ config, lib, inputs, pkgs, ... }: let
	hyprland = inputs.hyprland.packages.${pkgs.system};
	hyprland-plugins = inputs.hyprland-plugins.packages.${pkgs.system};
	hyprpaper = inputs.hyprpaper.packages.${pkgs.system};
	hyprpicker = inputs.hyprpicker.packages.${pkgs.system};
	hypridle = inputs.hypridle.packages.${pkgs.system};
	hyprlock = inputs.hyprlock.packages.${pkgs.system};

	colorPalette = config.colorScheme.palette;

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

	concatedString = seperator: list: ((lib.convertor {
		default = (seperator: list: "");
		isList = (seperator: list: builtins.concatStringsSep seperator list);
		isString = (seperator: list: list);
	} list) seperator list);
	getMods = mods: (concatedString "_" mods);
	getParams = params: (concatedString ", " params);

	listToBinds = dispatcher: modKeys: list: map (x: "${getMods modKeys}, ${x.keys}, ${dispatcher}, ${getParams x.params}") list;
in {
	imports = let
		configAttrs = { inherit hyprland hyprland-plugins hyprpaper hyprpicker hypridle hyprlock; };
	in [
		(import ./hypridle.nix configAttrs)
		(import ./hyprlock.nix configAttrs)
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

				# Hyprcursors
				"HYPRCURSOR_THEME, Catppuccin-Frappe-Green-Hyprcursors"
				"HYPRCURSOR_SIZE, ${toString config.home.pointerCursor.size}"
			];

			# Autostart
			exec-once = [
				"${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
				"${lib.getExe hypridle.hypridle}"
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
			] ++ listToBinds "movetoworkspace" "${mod}" [
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
				setVolume = type: action: "${pkgs.pulseaudio}/bin/pactl set-${
					if
						(lib.contains type [ "sink" "source" ])
					then
						type
					else
						"sink"
				}-${
					if
						(lib.contains type [ "volume" "mute" ])
					then
						type
					else
						"volume"
				}";
			in [
				{ keys = "XF86AudioRaiseVolume"; params = "${setVolume "sink" "volume"} @DEFAULT_SINK@ +5%"; }
				{ keys = "XF86AudioLowerVolume"; params = "${setVolume "sink" "volume"} @DEFAULT_SINK@ -5%"; }
				{ keys = "XF86AudioMute"; params = "${setVolume "sink" "mute"} @DEFAULT_SINK@"; }
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
				"col.active_border" = "rgb(${colorPalette.base08}) rgb(${colorPalette.base0B}) 45deg";
				"col.inactive_border" = "rgba(${colorPalette.base01}aa)";

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
				"col.shadow" = "rgba(${colorPalette.base01}ee)";
			};

			animations = {
				enabled = true;

				bezier = "myBezier, 0.5, .2, .5, 1.2";
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

			misc = {
				enable_swallow = true;
				swallow_regex = "^(Alacritty)$";

				mouse_move_enables_dpms = true;
    		key_press_enables_dpms = true;
			};

			windowrulev2 = [
				"float, class:polkit-gnome-authentication-agent-1"
				"center, class:polkit-gnome-authentication-agent-1"
				"size 872 436, class:polkit-gnome-authentication-agent-1"
				"stayfocused, class:polkit-gnome-authentication-agent-1"
				"idleinhibit always, class:polkit-gnome-authentication-agent-1"
				"dimaround, class:polkit-gnome-authentication-agent-1"
				"xray on, class:polkit-gnome-authentication-agent-1"
			];

			plugin = {
				hyprbars = {
					bar_height = 20;

					bar_precedence_over_border = true;
					bar_part_of_window = true;

					bar_text_font = "FiraCode Nerd Font Mono";

					bar_color = "rgb(${colorPalette.base00})";
					"col.text" = "rgb(${colorPalette.base05})";

					hyprbars-button = [
						"rgb(${colorPalette.base08}), 15,󰅖, hyprctl dispatch killactive"
						"rgb(${colorPalette.base0A}), 15,󰖯, hyprctl dispatch fullscreen 1"
						"rgb(${colorPalette.base0D}), 15,󰖰, ${minimize}"
					];
				};
			};
		};
	};
}
