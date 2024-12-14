{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [ ani-skip ];
  
  programs.mpv = {
    enable = true;

    scripts = with pkgs; [ ani-skip ];
  };
}
