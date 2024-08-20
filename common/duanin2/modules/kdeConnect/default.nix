{ persistDirectory, ... }: {
  services.kdeconnect = {
    enable = true;

    indicator = false;
  };

  home.persistence.${persistDirectory} = {
    directories = [ ".config/kdeconnect" ];
  };
}
