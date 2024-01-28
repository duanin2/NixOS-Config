{ pkgs, ... }: {
  home.packages = with pkgs; [
    libreoffice-qt
  ];

  home.sessionVariables = {
    "SAL_USE_VCLPLUGIN" = "qt5";
  };
}