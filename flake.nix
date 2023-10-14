{
  description = "Configuration for my nix machines.";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # NUR
    nur.url = "github:nix-community/NUR";

    # Chaotic's Nyx
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # NixOS hardware
    hardware.url = "nixos-hardware";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Emacs overlay
    emacs = {
      url = "emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Eww systray
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eww = {
      url = "github:ralismark/eww/tray-3";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    # Nix colors
    base16-schemes = {
      url = "github:tinted-theming/base16-schemes";
      flake = false;
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.base16-schemes.follows = "base16-schemes";
    };
  };

  outputs = { self, ... }@inputs: let
    inherit (self) outputs;
    nixpkgs-lib = inputs.nixpkgs.lib;
    hm-lib = inputs.home-manager.lib;
    lib = nixpkgs-lib;
    
    forAllSystems = lib.genAttrs [
      "x86_64-linux"
    ];

    nixCommon = { lib, pkgs, ... }: {
      enable = true; # DO NOT DISABLE
      package = lib.mkDefault pkgs.nixVersions.stable;

      checkConfig = true;

      registry = {
        "nixpkgs" = {
          flake = inputs.nixpkgs;
          exact = true;
        };
        "home-manager" = {
          flake = inputs.home-manager;
          exact = true;
        };
        "agenix" = {
          flake = inputs.agenix;
          exact = true;
        };
        "nur" = {
          flake = inputs.nur;
          exact = true;
        };
        "chaotic" = {
          flake = inputs.chaotic;
          exact = true;
        };
        "hyprland" = {
          flake = inputs.hyprland;
          exact = true;
        };
        "eww" = {
          flake = inputs.eww;
          exact = true;
        };
      };

      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        auto-optimise-store = true;
        accept-flake-config = true;
        builders-use-substitutes = true;
        connect-timeout = 10;
        cores = 2;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        fallback = true;
        http-connections = 0;
        log-lines = 20;
        max-jobs = 2;
        preallocate-contents = true;
        use-xdg-base-directories = true;
        allow-import-from-derivation = true;
        
        keep-going = true;
        keep-failed = false;
        keep-outputs = true;
        keep-env-derivations = false;
        keep-derivations = false;
        
        min-free = 1073741824;
        min-free-check-interval = 20;
        
        substituters = [
          # Hyprland
          "https://hyprland.cachix.org"
          
          # nix-community
          "nix-community.cachix.org"
          
          # Chaotic's Nyx
          "https://nyx.chaotic.cx"
        ];
        trusted-public-keys = [
          # Hyprland
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          
          # nix-community
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          
          # Chaotic's Nyx
          "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        ];
      };
    };

    nixNixosCommon = { ... }: {
      optimise = {
        automatic = true;
        dates = [ "1d" ];
      };
      
      gc = {
        randomizedDelaySec = "60min";
        persistent = true;
        dates = "daily";
        automatic = true;
      };
      
      daemonIOSchedPriority = 0;
      daemonIOSchedClass = "best-effort";
      daemonCPUSchedPolicy = "other";
      
      channel.enable = false;
    };

    nixHmCommon = { ... }: { };

    chaoticNyx = {
      cache.enable = true;
      overlay = {
        enable = true;
        onTopOf = "user-pkgs";
      };
    };
  in rec {
    inherit nixpkgs-lib hm-lib;

    # Nix config
    nixConfig = (nixCommon {}).settings;
    
    # Packages
    packages = forAllSystems (system: let 
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
      import ./pkgs { inherit pkgs; }
    );
    # Devshell
    devShells = forAllSystems (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
      import ./shell.nix { inherit pkgs; }
    );

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {
      inherit inputs;
      lib = nixpkgs-lib;
    };
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      Duanin2Laptop = let 
        system = "x86_64-linux";
        lib = nixpkgs-lib;
      in lib.nixosSystem {
        inherit system lib;
        specialArgs = { inherit inputs outputs; };
        modules = (with inputs; [
          # Chaotic's nix
          chaotic.nixosModules.default
          
          # Impermanence
          impermanence.nixosModule
            
          # Agenix
	        agenix.nixosModules.default
          
          # Hyprland
          hyprland.nixosModules.default
          
          # Home Manager
          home-manager.nixosModules.default
        ])
        ++ (with inputs.hardware.nixosModules; [
          common-cpu-intel
          common-gpu-intel
          common-gpu-nvidia
          common-pc-laptop-acpi_call
          common-pc-laptop-ssd
          common-pc
        ])
        ++ [
          # Set configuration revision
          { system.configurationRevision = if self ? rev then self.rev else "dirty"; }
          
          # NUR
          { nixpkgs.overlays = [ inputs.nur.overlay ]; }
          ({ inputs, pkgs, ... }: let
            nurNoPkgs = import inputs.nur {
              nurpkgs = import inputs.nixpkgs { inherit system; };
            };
          in {
            imports = [
              # NixOS Config
              ./nixos/Duanin2Laptop/configuration.nix

              # Home Manager Config
              ({ inputs, ... }: let
                lib = hm-lib;
              in {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users = {
                    "duanin2" = {
                      _module.args = {
                        inherit inputs outputs;
                      };
                      
                      imports = [
                        # Config
                        ./nixos/Duanin2Laptop/home-manager/duanin2/home.nix
                      ] ++ (with nurNoPkgs.repos; [
                        # NUR
                        rycee.hmModules.emacs-init
                      ]) ++ (with inputs; [
                        # Chaotic's Nyx
                        chaotic.homeManagerModules.default

                        # Nix Colors
                        nix-colors.homeManagerModules.default

                        # GTK
                        outputs.homeManagerModules.gtk

                        # Impermanence
                        impermanence.nixosModules.home-manager.impermanence
                      ]);
                    };
                  };
                };
              })
            ];
          })
          
          # Set nix configuration
          ({ lib, pkgs, ... }: let
            args = { inherit lib pkgs; };
          in {
            nix = (nixCommon args) // (nixNixosCommon args) // { };

            home-manager.users = {
              "duanin2" = { nix = (nixCommon args) // (nixHmCommon args) // { }; };
            };
          })

          # Chaotic's Nyx
          {
            chaotic.nyx = chaoticNyx;
            
            home-manager.users = {
              "duanin2" = {
                chaotic.nyx = chaoticNyx;
              };
            };
          }
        ];
      };
    };
  };
}
