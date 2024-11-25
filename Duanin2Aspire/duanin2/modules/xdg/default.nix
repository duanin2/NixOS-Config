{ homeDirectory, persistDirectory, config, ... }: let
  desktop = "Plocha";
  documents = "Dokumenty";
  download = "Stažené";
  music = "Hudba";
  pictures = "Obrázky";
  publicShare = "Veřejné";
  templates = "Šablony";
  videos = "Videa";
in {
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      
      createDirectories = true;

      desktop = "${homeDirectory}/${desktop}";
      documents = "${homeDirectory}/${documents}";
      download = "${homeDirectory}/${download}";
      music = "${homeDirectory}/${music}";
      pictures = "${homeDirectory}/${pictures}";
      publicShare = "${homeDirectory}/${publicShare}";
      templates = "${homeDirectory}/${templates}";
      videos = "${homeDirectory}/${videos}";
    };
  };

  home.persistence.${persistDirectory} = {
    directories = [
      desktop
      documents
      download
      music
      pictures
      publicShare
      templates
      videos
    ];
  };
}
