{ ... }: {
  home.persistence."/persist/home/duanin2" = {
    directories = [
      "Dokumenty"
      "Hry"
      "Hudba"
      "KeePass"
      "Obrázky"
      "Plocha"
      "Stažené"
      "Veřejné"
      "Videa"
      "dev"
      "Šablony"
      ".android"
      ".gnupg"
      ".mozilla"
      ".ssh"
      ".thunderbird"
      ".local/share/PrismLauncher"
      ".local/share/bottles"
      ".local/share/direnv"
      ".local/share/godot"
      ".local/share/lutris"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [ ];
    allowOther = true;
  };
}