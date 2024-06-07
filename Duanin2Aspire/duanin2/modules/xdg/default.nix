{ homeDirectory, ... }: {
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
}
