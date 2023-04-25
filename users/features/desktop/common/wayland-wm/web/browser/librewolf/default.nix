{ pkgs, ... }: {
  home.packages = with pkgs; [
    librewolf
  ];

  xdg.mimeApps = {
    enable = pkgs.lib.mkForce true;
    defaultApplications = {
      "text/html" = [ "librewolf.desktop" ];
    };
  };
}