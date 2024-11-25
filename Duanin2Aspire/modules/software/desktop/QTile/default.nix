{ pkgs, ... }: {
  services.xserver.windowManager.qtile = {
    enable = true;
    package = pkgs.qtile-module_git;
    extraPackages = _pythonPackages: [ pkgs.qtile-extras_git ];
  };
}
