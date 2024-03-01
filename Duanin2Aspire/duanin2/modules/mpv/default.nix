{ pkgs, ... }: {
  programs.mpv = {
    enable = true;

    /*
    scripts = [
      ((pkgs.callPackage ./ani-skip.nix {}).script)
    ];
    */
  };
}