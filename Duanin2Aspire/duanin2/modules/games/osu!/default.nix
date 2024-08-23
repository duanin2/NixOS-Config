{ pkgs, persistDirectory, ... }: {
  home.packages = with pkgs; [ osu-lazer-bin ];

  home.persistence.${persistDirectory}.directories = [ ".local/share/osu" ];
}
