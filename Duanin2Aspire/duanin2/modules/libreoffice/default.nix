{ pkgs, persistDirectory, ... }: {
  home.packages = with pkgs; [
    libreoffice-qt
  ];

  home.sessionVariables = {
    "SAL_USE_VCLPLUGIN" = "qt5";
  };

  home.persistence.${persistDirectory}.directories = [
    ".config/libreoffice/4/user"
  ];
}
