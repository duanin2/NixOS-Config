{ pkgs, persistDirectory, ... }: {
  home.packages = with pkgs; [
    anki
  ];

  home.persistence.${persistDirectory}.directories = [
    ".local/share/Anki2"
  ];
}