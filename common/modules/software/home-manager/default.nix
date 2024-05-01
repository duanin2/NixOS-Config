{ inputs, lib, customPkgs, nur, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = { inherit inputs lib customPkgs nur; };

    useGlobalPkgs = true;
    useUserPackages = true;

    users."duanin2".imports = with inputs; [
      chaotic.homeManagerModules.default
    ];
  };
}