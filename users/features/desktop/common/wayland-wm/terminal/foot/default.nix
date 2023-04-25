{pkgs, ...}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font Mono:size=9";
        dpi-aware = "yes";
      };
      environment = {};
      bell = {};
      scrollback = {};
      url = {};
      cursor = {
        style = "beam";
        blink = "yes";
      };
      mouse = {};
      colors = {
        foreground = "c6d0f5";
        background = "303446";

        regular0 = "51576d";
        regular1 = "e78284";
        regular2 = "a6d189";
        regular3 = "e5c890";
        regular4 = "8caaee";
        regular5 = "f4b8e4";
        regular6 = "81c8be";
        regular7 = "b5bfe2";

        bright0 = "626880";
        bright1 = "e78284";
        bright2 = "a6d189";
        bright3 = "e5c890";
        bright4 = "8caaee";
        bright5 = "f4b8e4";
        bright6 = "81c8be";
        bright7 = "a5adce";
      };
      csd = {
        preferred = "none";
      };
      key-bindings = {};
      search-bindings = {};
      url-bindings = {};
      text-bindings = {};
      mouse-bindings = {};
    };
  };
}
