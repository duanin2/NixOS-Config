{
	description = "My NixOS configuration.";

	nixConfig = {
		substituters = [
			"https://0uptime.cachix.org/"
			"https://nix-community.cachix.org/"
			"https://hyprland.cachix.org"
			"https://nyx.chaotic.cx/"
		];
		trusted-public-keys = [
			"0uptime.cachix.org-1:ctw8yknBLg9cZBdqss+5krAem0sHYdISkw/IFdRbYdE="
			"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
			"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
			"nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
			"chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
		];
	};

	inputs = {
		nixpkgs = {
			url = "github:NixOS/nixpkgs/nixos-23.11";
		};
		nixpkgs-unstable = {
			url = "github:NixOS/nixpkgs/nixos-unstable";
		};

		home-manager = {
			url = "github:nix-community/home-manager/release-23.11";
			inputs = {
				nixpkgs.follows = "nixpkgs";
			};
		};
		impermanence = {
			url = "github:nix-community/impermanence";
		};

		nur = {
			url = "github:nix-community/nur";
		};
		chaotic = {
			url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
				home-manager.follows = "home-manager";
			};
		};

		rpi5 = {
			url = "gitlab:vriska/nix-rpi5";
			inputs = {
				nixpkgs.follows = "nixpkgs";
			};
		};

		hyprland = {
			url = "github:hyprwm/hyprland";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
				systems.follows = "systems";

				hyprcursor.follows = "hyprcursor";
				hyprland-protocols.follows = "hyprland-protocols";
				hyprlang.follows = "hyprlang";
				xdph.follows = "xdph";
			};
		};
		hyprland-protocols = {
			url = "github:hyprwm/hyprland-protocols";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
				systems.follows = "systems";
			};
		};
		hyprland-plugins = {
			url = "github:hyprwm/hyprland-plugins";
			inputs = {
				hyprland.follows = "hyprland";
				systems.follows = "systems";
			};
		};
		hyprcursor = {
			url = "github:hyprwm/hyprcursor";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
				systems.follows = "systems";

				hyprlang.follows = "hyprlang";
			};
		};
		xdph = {
			url = "github:hyprwm/xdg-desktop-portal-hyprland";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
				systems.follows = "systems";

				hyprlang.follows = "hyprlang";
				hyprland-protocols.follows = "hyprland-protocols";
			};
		};
		hyprpaper = {
			url = "github:hyprwm/hyprpaper";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";

				hyprlang.follows = "hyprlang";
			};
		};
		hyprpicker = {
			url = "github:hyprwm/hyprpicker";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
			};
		};
		hypridle = {
			url = "github:hyprwm/hypridle";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
				systems.follows = "systems";

				hyprlang.follows = "hyprlang";
			};
		};
		hyprlock = {
			url = "github:hyprwm/hyprlock";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
				systems.follows = "systems";

				hyprlang.follows = "hyprlang";
			};
		};
		hyprlang = {
			url = "github:hyprwm/hyprlang";
			inputs = {
				nixpkgs.follows = "nixpkgs-unstable";
				systems.follows = "systems";
			};
		};
		systems.url = "github:nix-systems/default-linux";

		nix-colors.url = "github:misterio77/nix-colors";

		godot-nixpkgs = {
			url = "github:ilikefrogs101/nixpkgs";
		};
	};

	outputs = inputs: let
		lib = inputs.nixpkgs.lib.extend (final: prev: (import ./lib final prev) // inputs.home-manager.lib);

		eachSystem = lib.genAttrs (import inputs.systems);
	in rec {
		nixosConfigurations = {
			"Duanin2Aspire" = let
				system = "x86_64-linux";
				customPkgs = legacyPackages.${system};
				nur = import inputs.nur rec {
					pkgs = import inputs.nixpkgs { inherit system; };
					nurpkgs = pkgs;
				};
			in lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs lib customPkgs nur; };

				modules = [
					./Duanin2Aspire

					inputs.impermanence.nixosModules.impermanence
					inputs.home-manager.nixosModules.home-manager
					{
						imports = [ ];

						home-manager = {
							extraSpecialArgs = { inherit inputs lib customPkgs nur; };

							useGlobalPkgs = true;
							useUserPackages = true;

							users."duanin2".imports = [
								inputs.impermanence.nixosModules.home-manager.impermanence
								inputs.chaotic.homeManagerModules.default
								inputs.nix-colors.homeManagerModule
							];
						};
					}

					inputs.chaotic.nixosModules.default
				];
			};
			"RaspberryPi5" = let
				system = "aarch64-linux";
				customPkgs = legacyPackages.${system};
				nur = import inputs.nur rec {
					pkgs = import inputs.nixpkgs { inherit system; };
					nurpkgs = pkgs;
				};
			in lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs lib customPkgs nur; };

				modules = [
					./RaspberryPi5

					inputs.home-manager.nixosModules.home-manager
					{
						imports = [ ];

						home-manager = {
							extraSpecialArgs = { inherit inputs lib customPkgs nur; };

							useGlobalPkgs = true;
							useUserPackages = true;

							users."duanin2".imports = [
								inputs.chaotic.homeManagerModules.default
							];
						};
					}

					inputs.chaotic.nixosModules.default
				];
			};
			"bcachefsIso" = let
				system = "x86_64-linux";
				customPkgs = legacyPackages.${system};
				nur = import inputs.nur rec {
					pkgs = import inputs.nixpkgs { inherit system; };
					nurpkgs = pkgs;
				};
			in lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs lib customPkgs nur; };

				modules = [
					"${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5-new-kernel.nix"
					({ lib, pkgs, ... }: {
						boot.supportedFilesystems = {
							bcachefs = true;
							zfs = lib.mkForce false;
						};
          })
				];
			};
		};
		homeConfigurations = {
			"SchoolServer" = let
				system = "x86_64-linux";
				pkgs = import inputs.nixpkgs { inherit system; };
				customPkgs = legacyPackages.${system};
				nur = import inputs.nur rec {
					inherit pkgs;
					nurpkgs = pkgs;
				};
			in lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = { inherit pkgs inputs lib customPkgs nur; };

				modules = [
					./SchoolServer

					{
						imports = [];
					}

					inputs.chaotic.homeManagerModules.default
				];
			};
		};

		legacyPackages = eachSystem (system: let
			pkgs = import inputs.nixpkgs { inherit system; };
			nur = import inputs.nur { inherit pkgs; };
			hyprcursor = inputs.hyprcursor.packages.${system};
		in import ./packages { inherit pkgs nur hyprcursor; });
	};
}
