{ pkgs, ... }: {
  programs.mangohud = {
    enable = true;
    package = pkgs.mangohud_git;
  };
}