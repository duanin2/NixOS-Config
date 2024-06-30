{ persistDirectory, ... }: {
  services.kdeconnect = {
    enable = true;

    indicator = true;
  };

  home.persistence.${persistDirectory} = {
    directories = [ ".config/kdeconnect" ];
  };
}
