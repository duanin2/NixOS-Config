{ pkgs, ... }: {
  services.xserver.windowManager.qtile = {
    enable = true;
    backend = "wayland";
    package = pkgs.qtile-module_git;
    extraPackages = _pythonPackages: [ pkgs.qtile-extras_git ];
  };
  # if you want a proper wayland+qtile session, and/or a "start-qtile" executable in PATH:
  chaotic.qtile.enable = true;
}
