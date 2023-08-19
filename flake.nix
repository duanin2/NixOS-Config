{
  description = "Configuration for my nix machines.";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
	      darwin.follows = "";
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
      url = "github:hyprwm/Hyprland/v0.28.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    emacs = {
      url = "emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Mozilla packages
    mozilla.url = "github:mozilla/nixpkgs-mozilla";

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
    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];
    nixConfig = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
      accept-flake-config = true;
      builders-use-substitutes = true;
      connect-timeout = 5;
      cores = 4;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      fallback = true;
      http-connections = 0;
      log-lines = 20;
      max-jobs = 1;
      preallocate-contents = true;
      use-xdg-base-directories = true;
      allow-import-from-derivation = true;

      substituters = [
        # Hyprland
        "hyprland.cachix.org"

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
  in rec {
    inherit nixConfig;
    
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
    overlays = import ./overlays { inherit inputs; };
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      Duanin2Laptop = let 
        system = "x86_64-linux";
      in inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = [
          # Set configuration revision
          { system.configurationRevision = if self ? rev then self.rev else "dirty"; }

          # NUR
          { nixpkgs.overlays = [ inputs.nur.overlay ]; }
          ({ pkgs, ... }: let
            nurNoPkgs = import inputs.nur {
              nurpkgs = import inputs.nixpkgs { inherit system; };
            };
          in {
            # My nixos configuration file
            imports = [
              ./nixos/configuration.nix
            ];
          })

          # Set nix configuration
          { nix.settings = nixConfig; }
        ] ++ (with inputs; [
          # Chaotic's nix
          chaotic.nixosModules.default

          # Impermanence
          impermanence.nixosModule

          # Agenix
	        agenix.nixosModules.default
        ]) ++ (with inputs.hardware.nixosModules; [
          # NixOS hardware
          common-cpu-intel
          common-gpu-intel
          common-gpu-nvidia
          common-pc-laptop-acpi_call
          common-pc-laptop-ssd
          common-pc
        ]);
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "duanin2@Duanin2Laptop" = let 
        system = "x86_64-linux";
      in inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          # NUR
          { nixpkgs.overlays = [ inputs.nur.overlay ]; }
          ({ pkgs, ... }: let
            nurNoPkgs = import inputs.nur {
              nurpkgs = import inputs.nixpkgs { inherit system; };
            };
          in {
            # My home-manager configuration file
            imports = [
              nurNoPkgs.repos.rycee.hmModules.emacs-init
              ./home-manager/home.nix
            ];
          })

          # Set nix configuration
          { nix.settings = nixConfig; }
        ] ++ (with inputs; [
          # Chaotic's nix
          chaotic.homeManagerModules.default

          # Impermanence
          impermanence.nixosModules.home-manager.impermanence

          # Agenix
	        agenix.homeManagerModules.default

          # Nix colors
          nix-colors.homeManagerModules.default
        ]) ++ [
          homeManagerModules.gtk
        ];
      };
    };
  };
}
