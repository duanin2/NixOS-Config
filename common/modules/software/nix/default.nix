{ inputs, lib, ... }: {
	imports = [
		./nixpkgs
	];

	nix = {
		enable = lib.mkForce true;

		settings = {
			experimental-features = "flakes nix-command";

			auto-optimise-store = true;

			max-jobs = 1;
			cores = 4;

			keep-derivations = false;
			keep-going = true;
			min-free = 1073741824;

			substituters = [
				"https://0uptime.cachix.org/"
				"https://nix-community.cachix.org/"
				"https://hyprland.cachix.org"
			];
			trusted-public-keys = [
				"0uptime.cachix.org-1:ctw8yknBLg9cZBdqss+5krAem0sHYdISkw/IFdRbYdE="
				"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
				"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
			];
			download-speed = 1573;

			trusted-users = [
				"@wheel"
				"root"
				"duanin2"
			];

			accept-flake-config = true;
		};

		registry = with inputs; {
			"nixpkgs" = {
				from = {
					id = "nixpkgs";
					type = "indirect";
				};
				flake = nixpkgs;
			};

			"home-manager" = {
				from = {
					id = "home-manager";
					type = "indirect";
				};
				flake = home-manager;
			};
			"impermanence" = {
				from = {
					id = "impermanence";
					type = "indirect";
				};
				flake = impermanence;
			};

			"nur" = {
				from = {
					id = "nur";
					type = "indirect";
				};
				flake = nur;
			};
			"chaotic" = {
				from = {
					id = "chaotic";
					type = "indirect";
				};
				flake = chaotic;
			};

			"rpi5" = {
				from = {
					id = "rpi5";
					type = "indirect";
				};
				flake = rpi5;
			};

			"emacs" = {
				from = {
					id = "emacs";
					type = "indirect";
				};
				flake = emacs;
			};

      /*
			"hyprland" = {
				from = {
					id = "hyprland";
					type = "indirect";
				};
				flake = hyprland;
			};
			"hyprland-plugins" = {
				from = {
					id = "hyprland-plugins";
					type = "indirect";
				};
				flake = hyprland-plugins;
			};
			"hyprcursor" = {
				from = {
					id = "hyprcursor";
					type = "indirect";
				};
				flake = hyprcursor;
			};
			"hyprpaper" = {
				from = {
					id = "hyprpaper";
					type = "indirect";
				};
				flake = hyprpaper;
			};
			"hyprpicker" = {
				from = {
					id = "hyprpicker";
					type = "indirect";
				};
				flake = hyprpicker;
			};
			"hypridle" = {
				from = {
					id = "hypridle";
					type = "indirect";
				};
				flake = hypridle;
			};
			"hyprlock" = {
				from = {
					id = "hyprlock";
					type = "indirect";
				};
				flake = hyprlock;
			};
      */
			"systems" = {
				from = {
					id = "systems";
					type = "indirect";
				};
				flake = systems;
			};

			"nix-colors" = {
				from = {
					id = "nix-colors";
					type = "indirect";
				};
				flake = nix-colors;
			};
		};

		gc = {
			automatic = true;

			dates = "daily";
			persistent = true;
		};
	};

	environment.persistence."/persist".users.root = {
		home = "/root";
		directories = [
			".cache/nix"
		];
	};
}