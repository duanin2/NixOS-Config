{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-staging.url = "nixpkgs/staging";

    # Home manager
    home-manager = {
      url = "home-manager";
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

    # NixOS hardware
    hardware.url = "nixos-hardware";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.27.2";
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
    # base16-schemes.url = "github:tinted-theming/base16-schemes";
    nix-colors = {
      url = "github:misterio77/nix-colors";
      # inputs.base16-schemes.follows = "base16-schemes";
    };
  };

  outputs = { self, ... }@inputs: let
    inherit (self) outputs;
    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];
  in rec {
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
            imports = [ ./nixos/configuration.nix ];
          })
        ] ++ (with inputs; [
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
        ] ++ (with inputs; [
          # Impermanence
          impermanence.nixosModules.home-manager.impermanence

          # Agenix
	  agenix.homeManagerModules.default

          # Nix colors
          nix-colors.homeManagerModules.default
        ]);
      };
    };
  };
}
