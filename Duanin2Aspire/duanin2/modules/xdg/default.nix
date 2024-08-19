{ homeDirectory, persistDirectory, config, ... }: {
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      
      createDirectories = true;

      desktop = "${homeDirectory}/Plocha";
      documents = "${homeDirectory}/Dokumenty";
      download = "${homeDirectory}/Stažené";
      music = "${homeDirectory}/Hudba";
      pictures = "${homeDirectory}/Obrázky";
      publicShare = "${homeDirectory}/Veřejné";
      templates = "${homeDirectory}/Šablony";
      videos = "${homeDirectory}/Videa";
    };
  };

  home.persistence.${persistDirectory} = {
    directories = let
      cfg = config.xdg.userDirs;
    in [
      cfg.desktop
      cfg.documents
      cfg.download
      cfg.music
      cfg.pictures
      cfg.publicShare
      cfg.templates
      cfg.videos
    ];
  };
}
