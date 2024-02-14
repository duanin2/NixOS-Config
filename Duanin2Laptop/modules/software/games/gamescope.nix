{ pkgs, ... }: {
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope_git;
    capSysNice = true;

    env = {
      "DRI_PRIME" = "1";
    };
  };
}