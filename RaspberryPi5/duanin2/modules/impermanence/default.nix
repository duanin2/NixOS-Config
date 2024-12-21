{ inputs, persistDirectory, ... }: {
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  home.persistence.${persistDirectory} = {
    directories = [
      ".gnupg"
      ".ssh"
    ];
    files = [ ];
    allowOther = true;
  };
}