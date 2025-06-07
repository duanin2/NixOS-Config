{ ... }: {
  services.mako = {
    enable = true;

    settings = {
      "app-name=osd" = {
max-visible = 1;
        invisible = 0;
        layer = "overlay";
        history = 0;
        anchor = "center";
        group-by = "app-name";
        format = "<b>%s</b>\\n%b";
      };
    };
  };
}