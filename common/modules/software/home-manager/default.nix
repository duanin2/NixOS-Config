{ inputs, lib, customPkgs, nur, ... }: {
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs lib customPkgs nur;
      modules = {
        common = rec {
          outPath = ../../../duanin2/modules;

          Mozilla = outPath + /Mozilla;
          shell = {
            outPath = outPath + /shell;

            prompts = outPath + /prompts;
          };
        };
      };
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "bak";

    users."duanin2".imports = with inputs; [
      chaotic.homeManagerModules.default
    ];
  };
}
