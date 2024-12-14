{ inputs, pkgs, ... }: let
  ani-skip = pkgs.ani-skip.overrideAttrs { passthru.scriptName = "skip.lua"; };
in {
  home.packages = [ ani-skip ];
  
  programs.mpv = {
    enable = true;

    scripts = [ ani-skip ];
  };
}
