{ pkgs, ... }: {
  programs.pidgin = {
    enable = true;

    plugins = with pkgs.pidginPlugins; [
      tdlib-purple
      pidgin-latex
      purple-discord
      purple-facebook
      pidgin-opensteamworks
    ];
  };
}
