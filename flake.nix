{
	description = "My NixOS configuration.";

	inputs = {
		nixpkgs = {
			url = "github:NixOS/nixpkgs/nixos-unstable";
		};
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs = {
				nixpkgs.follows = "nixpkgs";
			};
		};

		nur = {
			url = "github:nix-community/nur";
		};
		chaotic = {
			url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
			inputs = {
				nixpkgs.follows = "nixpkgs";
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
				nixpkgs.follows = "nixpkgs";
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
				nixpkgs.follows = "nixpkgs";
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
				nixpkgs.follows = "nixpkgs";
				systems.follows = "systems";

				hyprlang.follows = "hyprlang";
			};
		};
		xdph = {
			url = "github:hyprwm/xdg-desktop-portal-hyprland";
			inputs = {
				nixpkgs.follows = "nixpkgs";
				systems.follows = "systems";

				hyprlang.follows = "hyprlang";
				hyprland-protocols.follows = "hyprland-protocols";
			};
		};
		hyprpaper = {
			url = "github:hyprwm/hyprpaper";
			inputs = {
				nixpkgs.follows = "nixpkgs";

				hyprlang.follows = "hyprlang";
			};
		};
		hyprpicker = {
			url = "github:hyprwm/hyprpicker";
			inputs = {
				nixpkgs.follows = "nixpkgs";
			};
		};
		hypridle = {
			url = "github:hyprwm/hypridle";
			inputs = {
				nixpkgs.follows = "nixpkgs";
				systems.follows = "systems";

				hyprlang.follows = "hyprlang";
			};
		};
		hyprlock = {
			url = "github:hyprwm/hyprlock";
			inputs = {
				nixpkgs.follows = "nixpkgs";
				systems.follows = "systems";

				hyprlang.follows = "hyprlang";
			};
		};
		hyprlang = {
			url = "github:hyprwm/hyprlang";
			inputs = {
				nixpkgs.follows = "nixpkgs";
				systems.follows = "systems";
			};
		};
		systems.url = "github:nix-systems/default-linux";

		nix-colors.url = "github:misterio77/nix-colors";

		godot-nixpkgs = {
			url = "github:ilikefrogs101/nixpkgs";
		};
		nixpkgs-staging = {
			url = "github:NixOS/nixpkgs/staging";
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
			in inputs.nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = {
					inherit inputs lib customPkgs;
				};

				modules = [
					./Duanin2Aspire

					inputs.home-manager.nixosModules.home-manager
					{
						home-manager = {
							extraSpecialArgs = {
								inherit inputs lib customPkgs;
							};

							useGlobalPkgs = true;
							useUserPackages = true;
						};
					}

					{ nixpkgs.overlays = [ inputs.nur.overlay ]; }
					({ pkgs, ... }: let
						nur-no-pkgs = import inputs.nur {
							nurpkgs = import inputs.nixpkgs { inherit system; };
						};
					in {
						imports = [ ];

						home-manager.users = {
							"duanin2".imports = [
								inputs.chaotic.homeManagerModules.default
								inputs.nix-colors.homeManagerModule
							];
						};
					})

					inputs.chaotic.nixosModules.default
				];
			};
			"RaspberryPi5" = let
				system = "aarch64-linux";
				customPkgs = legacyPackages.${system};
			in inputs.nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = {
					inherit inputs lib customPkgs;
				};

				modules = [
					./RaspberryPi5

					inputs.home-manager.nixosModules.home-manager
					{
						home-manager = {
							extraSpecialArgs = {
								inherit inputs lib customPkgs;
							};

							useGlobalPkgs = true;
							useUserPackages = true;
						};
					}

					{ nixpkgs.overlays = [ inputs.nur.overlay ]; }
					({ config, pkgs, ... }: let
						nur-no-pkgs = import inputs.nur {
							nurpkgs = import inputs.nixpkgs { inherit system; };
						};
					in {
						imports = [ ];

						home-manager.users = {
							"duanin2".imports = [
								inputs.chaotic.homeManagerModules.default
							];
						};

						home-manager.extraSpecialArgs = (config.home-manager.extraSpecialArgs or {}) // { inherit nur-no-pkgs; };
					})

					inputs.chaotic.nixosModules.default
				];
			};
		};
		homeConfigurations = {
			"SchoolServer" = let
				system = "x86_64-linux";
				pkgs = inputs.nixpkgs.legacyPackages.${system};
			in inputs.home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = {
					inherit pkgs inputs lib;
					customPkgs = legacyPackages.${system};
				};

				modules = [
					./SchoolServer

					{ nixpkgs.overlays = [ inputs.nur.overlay ]; }
					({ pkgs, ... }: let
						nur-no-pkgs = import inputs.nur {
							nurpkgs = import inputs.nixpkgs { inherit system; };
						};
					in {
						imports = [];
					})

					inputs.chaotic.homeManagerModules.default
				];
			};
		};

		legacyPackages = eachSystem (system: let
			pkgs = import inputs.nixpkgs { inherit system; };
			nur = import inputs.nur { inherit pkgs; };
		in import ./packages { inherit pkgs nur; });
	};
}
