{ pkgs, persistDirectory, ... }: {
  home.packages = with pkgs; [
    twtxt
  ];

  home.persistence.${persistDirectory}.directories = [
    ".config/twtxt"
  ];
}