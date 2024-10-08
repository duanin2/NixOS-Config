{ inputs, pkgs, ... }: let
  ani-skip = (pkgs.callPackage (inputs.ani-skip-nixpkgs + /pkgs/by-name/an/ani-skip/package.nix) { }).overrideAttrs { passthru.scriptName = "skip.lua"; };
in {
  home.packages = [ ani-skip ];
  
  programs.mpv = {
    enable = true;

    scripts = [ ani-skip ];
  };
}
