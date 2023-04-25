{ pkgs, ... }: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "pcmanfm.desktop" ];
    };
  };

  home.packages = with pkgs; [
    pcmanfm
  ];
}
