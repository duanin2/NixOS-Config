{ config, pkgs, lib, ... }: let
  cfg = config.programs.thunderbird;
in {
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird;

    profiles = {
      "default" = {
        isDefault = true;
        withExternalGnupg = true;

        extraConfig = let
          baseConfig = pkgs.fetchzip {
            url = "https://github.com/HorlogeSkynet/thunderbird-user.js/archive/refs/heads/master.zip";
            hash = "sha256-vRpzOwM1KLwTa5NgvP1jw80fqG0gS3k446sRKzoHwNs=";
          };
        in builtins.readFile "${baseConfig}/user.js";
      };
    };
  };
}
