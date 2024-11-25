{ persistDirectory, pkgs, ... }: {
  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;

    indicator = false;
  };

  home.persistence.${persistDirectory} = {
    directories = [ ".config/kdeconnect" ];
  };
}
