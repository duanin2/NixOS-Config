{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # NixOX Hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Hyprland
    hyprland.url = "github:hyprwm/hyprland/v0.23.0beta";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    # Alejandra
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    # PollyMC
    pollymc.url = "github:fn2006/PollyMC/6.3";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs {inherit pkgs;}
    );
    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix {inherit pkgs;}
    );

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays;
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      Duanin2Laptop = nixpkgs.lib.nixosSystem rec {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          # > Our main nixos configuration file <
          {
            environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
          }
          ./hosts/Duanin2Laptop
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager switch --flake .#your-username@your-hostname'
    homeConfigurations = {
      "duanin2@Duanin2Laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./users/duanin2.nix
        ];
      };
    };
  };
}
