{ customPkgs, ... }: {
  home.packages = with customPkgs; [ mpvScripts.ani-skip ];
  
  programs.mpv = {
    enable = true;

    scripts = with customPkgs.mpvScripts; [ ani-skip ];
  };
}
