{ pkgs, ... }: {
  xdg.mimeApps = {
    enable = pkgs.lib.mkForce true;
    defaultApplications = {
      "inode/directory" = [ "pcmanfm-qt.desktop" ];
    };
  };

  home.packages = with pkgs; [
    pcmanfm-qt
  ];
}
