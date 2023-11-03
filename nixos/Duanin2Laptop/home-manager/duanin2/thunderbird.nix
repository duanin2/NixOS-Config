{ config, pkgs, ... }: let
  cfg = config.programs.thunderbird;
in {
  programs.thunderbird = {
    enable = true;
    package = (pkgs.thunderbird.overrideAttrs (old: {
      version = "121.0a1";
    }));

    profiles = {
      "default" = {
        isDefault = true;
        withExternalGnupg = true;

        extraConfig = let
          baseConfig = pkgs.fetchzip {
            url = "https://github.com/HorlogeSkynet/thunderbird-user.js/archive/refs/heads/master.zip";
            hash = "sha256-IfQNepLwoG9qygeDGj5egnLQUR47LOjBV1PFJtt0Z64=";
          };
        in builtins.readFile "${baseConfig}/user.js";
      };
    };
  };
}
