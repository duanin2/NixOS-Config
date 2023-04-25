{ pkgs, ... }: {
  home.packages = with pkgs; [
    thunderbird
  ];

  xdg.mimeApps = {
    enable = pkgs.lib.mkForce true;
    defaultApplications = {
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "message/rfc822" = [ "thunderbird.desktop" ];
      "x-scheme-handler/mid" = [ "thunderbird.desktop" ];
      "x-scheme-handler/news" = [ "thunderbird.desktop" ];
      "x-scheme-handler/snews" = [ "thunderbird.desktop" ];
      "x-scheme-handler/nntp" = [ "thunderbird.desktop" ];
      "x-scheme-handler/feed" = [ "thunderbird.desktop" ];
      "application/rss+xml" = [ "thunderbird.desktop" ];
      "application/x-extension-rss" = [ "thunderbird.desktop" ];
      "x-scheme-handler/webcal" = [ "thunderbird.desktop" ];
      "text/calendar" = [ "thunderbird.desktop" ];
      "application/x-extension-ics" = [ "thunderbird.desktop" ];
      "x-scheme-handler/webcals" = [ "thunderbird.desktop" ];
    };
  };
}