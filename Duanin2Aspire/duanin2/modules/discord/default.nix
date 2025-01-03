{ pkgs, persistDirectory, ... }: {
  home.packages = with pkgs; [
    webcord-vencord
    arrpc
  ];

  home.persistence.${persistDirectory}.directories = [
    ".config/WebCord"
  ];
}