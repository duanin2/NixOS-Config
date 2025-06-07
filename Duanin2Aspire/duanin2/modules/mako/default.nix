{ pkgs, config, ... }: let
  fontCfg = config.gtk.font;
in {
  services.mako = {
    enable = true;

    settings = {
      max-history = 20;
      default-timeout = 1000;

      on-button-left = "invoke-default-action";
      on-button-middle = "exec makoctl menu -n \"$id\" \"${pkgs.wofi}/bin/wofi --dmenu -p 'Select action: '\"";
      on-button-right = "dismiss";

      anchor = "top-right";
      font = "${fontCfg.name} ${toString fontCfg.size}";
      border-size = 1;
      border-radius = 12;
      
      "app-name=osd" = {
        invisible = 0;
        layer = "overlay";
        history = 0;
        anchor = "center";
        group-by = "app-name";
        format = "<b>%s</b>\\n%b";
      };
      "anchor=center" = {
        max-visible = 1;
      };
    };
  };
}