{ persistDirectory, pkgs, ... }: {
  programs.pidgin = {
    enable = true;

    plugins = with pkgs.pidginPackages; [
      # tdlib-purple # Unmaintained, apparently
      pidgin-latex
      purple-discord
      purple-facebook
      pidgin-opensteamworks
      pidgin-indicator
    ];
  };

  home.persistence.${persistDirectory}.directories = [ ".purple" ];
}
