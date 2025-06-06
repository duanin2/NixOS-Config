{ ... }: {
  services.mako = {
    enable = true;

    settings = {
      "app-name=set-volume" = {
        invisible = 0;
        layer = "overlay";
        history = 0;
        anchor = "";
        group-by = "app-name";
        format = "<b>%s</b>\n%b";
      };
    };
  };
}