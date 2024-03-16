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
		};

		gc = {
			automatic = true;

			dates = "daily";
			persistent = true;
		};
	};
}
