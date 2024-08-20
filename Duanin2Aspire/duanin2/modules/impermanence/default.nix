{ lib, config, inputs, pkgs, persistDirectory, ... }: {
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  home.persistence.${persistDirectory} = {
    directories = [
      "Hry"
      "dev"
      ".android"
      ".gnupg"
      ".local/share/Trash"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    allowOther = true;
  };
}
