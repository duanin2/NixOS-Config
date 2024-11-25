{
	description = "My NixOS configuration.";

	nixConfig = {
		extra-substituters = [
			"https://0uptime.cachix.org/"
			"https://nix-community.cachix.org/"
			"https://hyprland.cachix.org"
			"https://nyx.chaotic.cx/"
      "https://cuda-maintainers.cachix.org"
		];
		extra-trusted-public-keys = [
			"0uptime.cachix.org-1:ctw8yknBLg9cZBdqss+5krAem0sHYdISkw/IFdRbYdE="
			"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
			"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
			"nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
			"chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
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
			url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
			inputs = {
				nixpkgs.follows = "nixpkgs";

				hyprcursor.follows = "hyprcursor";
			};
		};
		hyprland-plugins = {
			url = "github:hyprwm/hyprland-plugins";
			inputs = {
				hyprland.follows = "hyprland";
			};
		};
		hyprcursor = {
			url = "github:hyprwm/hyprcursor";
			inputs = {
				nixpkgs.follows = "nixpkgs";
			};
		};
		hyprpaper = {
			url = "github:hyprwm/hyprpaper";
			inputs = {
				nixpkgs.follows = "nixpkgs";
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
			};
		};
		hyprlock = {
			url = "github:hyprwm/hyprlock";
			inputs = {
				nixpkgs.follows = "nixpkgs";
			};
		};

		systems.url = "github:nix-systems/default-linux";

		nix-colors.url = "github:misterio77/nix-colors";
		catppuccin.url = "github:catppuccin/nix";
    nix-wallpaper.url = "github:lunik1/nix-wallpaper";

    ani-skip-nixpkgs = {
      url = "github:diniamo/nixpkgs/ani-skip";
    };

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    /*
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    */
	};

	outputs = inputs: let
		lib = inputs.nixpkgs.lib.extend (final: prev: inputs.home-manager.lib // (import ./lib final prev));

		eachSystem = lib.genAttrs (import inputs.systems);
	in rec {
		inherit lib;
		nixosConfigurations = let
			nixosCdDvd = path: inputs.nixpkgs + "/nixos/modules/installer/cd-dvd" + path;

      commonModules = {
        outPath = ./common/modules;

        hardware.outPath = commonModules.outPath + /hardware;
        software = {
          outPath = commonModules.outPath + /software;

          network = commonModules.software.outPath + /network;
          shell = commonModules.software.outPath + /shell;
          kernel = {
            outPath = commonModules.software.outPath + /kernel;

            RaspberryPi = commonModules.software.kernel.outPath + /RaspberryPi;
          };
        };
      };
      isoModules.outPath = ./common/iso;
		in {
			"Duanin2Aspire" = let
				system = "x86_64-linux";
				customPkgs = legacyPackages.${system};
				nur = import inputs.nur rec {
					pkgs = import inputs.nixpkgs { inherit system; };
					nurpkgs = pkgs;
				};

        path = ./Duanin2Aspire;
			in lib.nixosSystem {
				inherit system;
				specialArgs = {
          inherit inputs lib customPkgs nur;
          modules = rec {
            local = {
              outPath = path + /modules;

              hardware = local.outPath + /hardware;
              software = {
                outPath = local.outPath + /software;

                network = local.software.outPath + /network;
                games = local.software.outPath + /games;
                bootloader = local.software.outPath + /bootloader;
                virtualization = local.software.outPath + /virtualization;
                desktops = local.software.outPath + /desktop;
                greeters = local.software.outPath + /greeters;
                theming = local.software.outPath + /theming;
              };
            };
            common = commonModules;
            iso = isoModules;
          };
        };

				modules = [
					path
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

        path = ./RaspberryPi5;
 			in lib.nixosSystem {
				inherit system;
				specialArgs = {
          inherit inputs lib customPkgs nur;
          modules = rec {
            local = {
              outPath = path + /modules;

              hardware.outPath = local.outPath + /hardware;
              software = {
                outPath = local.outPath + /software;

                network = local.software.outPath + /network;
                bootloader = local.software.outPath + /bootloader;
                web = local.software.outPath + /web;
              };
            };
            common = commonModules;
            iso = isoModules;
          };
        };

				modules = [
					path
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
					(nixosCdDvd + /installation-cd-graphical-plasma5.nix)

          (commonModules.software.kernel + /cachyos.nix)
					(isoModules + /default.nix)
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
					(nixosCdDvd + /installation-cd-minimal.nix)

					(commonModules.software.kernel.RaspberryPi + /vendor-latest.nix)
					(isoModules + /default.nix)

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

        path = ./SchoolServer;
			in lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = {
          inherit pkgs inputs lib customPkgs nur;
          modules = rec {
            local.outPath = path + /modules;
            common = {
              outPath = ./common/duanin2/modules;

              Mozilla = common.outPath + /Mozilla;
              shell = {
                outPath = common.outPath + /shell;

                prompts = common.shel.outPathl + /prompts;
              };
            };
          };
        };

				modules = [
					path

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
