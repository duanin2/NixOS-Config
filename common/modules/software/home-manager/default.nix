{ inputs, lib, customPkgs, nur, ... }: {
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs lib customPkgs nur;
      modules' = rec {
        common = {
          outPath = ../../../duanin2/modules;

          Mozilla = common.outPath + /Mozilla;
          shell = {
            outPath = common.outPath + /shell;

            prompts = common.shell.outPath + /prompts;
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
