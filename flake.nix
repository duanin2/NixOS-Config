{
	description = "My NixOS configuration.";

	nixConfig = {
		extra-substituters = [
			"https://0uptime.cachix.org/"
			"https://nix-community.cachix.org/"
			"https://hyprland.cachix.org"
			"https://nyx.chaotic.cx/"
		];
		extra-trusted-public-keys = [
			"0uptime.cachix.org-1:ctw8yknBLg9cZBdqss+5krAem0sHYdISkw/IFdRbYdE="
			"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
			"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
			"nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
			"chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
		];
	};

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
		impermanence = {
			url = "github:nix-community/impermanence";
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

		emacs = {
			url = "github:nix-community/emacs-overlay";
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
		catppuccin.url = "github:catppuccin/nix";

		godot-nixpkgs = {
			url = "github:ilikefrogs101/nixpkgs";
		};
	};

	outputs = inputs: let
		lib = inputs.nixpkgs.lib.extend (final: prev: (import ./lib final prev) // inputs.home-manager.lib);

		eachSystem = lib.genAttrs (import inputs.systems);
	in rec {
		inherit lib;
		nixosConfigurations = let
			nixosCdDvd = path: inputs.nixpkgs + "/nixos/modules/installer/cd-dvd" + path;
		in {
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
				] ++ (with inputs; [
					chaotic.nixosModules.default
				]);
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
				] ++ (with inputs; [
					chaotic.nixosModules.default
				]);
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
					(nixosCdDvd "/installation-cd-graphical-plasma5.nix")

					./Duanin2Aspire/modules/software/kernel/cachyos.nix
					./common/iso/default.nix
				] ++ (with inputs; [
					chaotic.nixosModules.default
				]);
			};
			"rpiIso" = let
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
					(nixosCdDvd "/installation-cd-minimal.nix")

					./RaspberryPi5/modules/software/kernel/vendor-latest.nix
					./common/iso/default.nix

					({ lib, ... }: {
						networking.wireless.enable = lib.mkForce false;
						boot.supportedFilesystems.bcachefs = lib.mkForce false;
					})
				] ++ (with inputs; [
					chaotic.nixosModules.default
				]);
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
