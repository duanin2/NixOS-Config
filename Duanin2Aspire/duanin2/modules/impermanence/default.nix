{ lib, config, inputs, pkgs, persistDirectory, ... }: {
  home.persistence.${persistDirectory} = {
    directories = [
      "Dokumenty"
      "Hudba"
      "KeePass"
      "Obrázky"
      "Plocha"
      "Stažené"
      "Veřejné"
      "Videa"
      "Šablony"
      "Hry"
      "dev"
      ".android"
      ".gnupg"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    allowOther = true;
  };
}
