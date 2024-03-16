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
			};
		};
		hyprland-plugins = {
			url = "github:hyprwm/hyprland-plugins";
			inputs = {
				hyprland.follows = "hyprland";
			};
		};

		godot-nixpkgs = {
			url = "github:ilikefrogs101/nixpkgs";
		};
	};

	outputs = inputs: let
		lib = inputs.nixpkgs.lib.extend (final: prev: (import ./lib final prev) // inputs.home-manager.lib);
	in {
		nixosConfigurations = {
			"Duanin2Aspire" = let
				system = "x86_64-linux";
			in inputs.nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs lib; };

				modules = [
					./Duanin2Aspire

					inputs.home-manager.nixosModules.home-manager
					{
						home-manager = {
							extraSpecialArgs = { inherit inputs lib; };

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
							];
						};
					})

					inputs.chaotic.nixosModules.default
				];
			};
			"RaspberryPi5" = let
				system = "aarch64-linux";
			in inputs.nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs lib; };

				modules = [
					./RaspberryPi5

					inputs.home-manager.nixosModules.home-manager
					{
						home-manager = {
							extraSpecialArgs = { inherit inputs lib; };

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
							];
						};
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
				extraSpecialArgs = { inherit pkgs inputs lib; };

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
	};
}
