{ inputs, pkgs, ... }: let
	hyprland = inputs.hyprland.packages.${pkgs.system};
	hyprland-plugins = inputs.hyprland-plugins.packages.${pkgs.system};

	mod = "SUPER";
	term = "${pkgs.alacritty}/bin/alacritty";

	moveFocus = key: dir: "${mod}, ${key}, movefocus, ${dir}";
	listToBinds = dispatcher: modKeys: list: map (x: "${modKeys}, ${x.keys}, ${dispatcher}, ${x.params}") list;
in {
	wayland.windowManager.hyprland = {
		enable = true;

		enableNvidiaPatches = true;
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
			exec-once = [ ];

			bind = [
				"${mod}, T, exec, ${term}"
				"${mod}, C, killactive,"
				"${mod}, H, movetoworkspacesilent, special"
				"${mod}, S, togglespecialworkspace"
				"${mod}, M, exit,"
				"${mod}, V, togglefloating,"
				"${mod}, P, pseudo," # dwindle
				"${mod}, J, togglesplit," # dwindle

				 # Movement
				 moveFocus "left" "l"
				 moveFocus "right" "r"
				 moveFocus "up" "u"
				 moveFocus "down" "d"

				 "${mod}, mouse_down, workspace, e+1"
				 "${mod}, mouse_up, workspace, e-1"

				 "${mod} SHIFT, mouse_down, movetoworkspace, e+1"
				 "${mod} SHIFT, mouse_up, movetoworkspace, e-1"
			] ++ listToBinds "workspace" mod [
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
			];

			bindm = [
				"${mod}, mouse:272, movewindow"
				"${mod}, mouse:273, resizewindow"
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

				blur = {
					enabled = true;

					size = 3;
					passes = 2;
					new_optimizations = true;
				};

				drop_shadow = true;
				shadow_range = 4;
				shadow_render_power = 3;
				col.shadow = "rgba(1a1a1aee)";
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
		};
	};
}
