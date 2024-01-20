{ inputs, lib, ... }: {
	imports = [
		./nixpkgs
	];

	nix = {
		settings = {
			experimental-features = "flakes nix-command";

			auto-optimise-store = true;

			max-jobs = 1;
			cores = 1;

			substituters = [
				"https://0uptime.cachix.org/"
				"https://nix-community.cachix.org/"
			];
			trusted-public-keys = [
				"0uptime.cachix.org-1:ctw8yknBLg9cZBdqss+5krAem0sHYdISkw/IFdRbYdE="
				"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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

			"kde2nix" = {
				from = {
					id = "kde2nix";
					type = "indirect";
				};
				flake = kde2nix;
			};
		};

		gc = {
			automatic = true;

			dates = "weekly";
			persistent = true;
		};
	};
}