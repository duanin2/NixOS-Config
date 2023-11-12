{ config, pkgs, lib, ... }: let
  cfg = config.programs.thunderbird;
in {
  programs.thunderbird = {
    enable = true;
    package = let
      baseConfig = pkgs.fetchzip {
        url = "https://github.com/HorlogeSkynet/thunderbird-user.js/archive/refs/heads/master.zip";
        hash = "sha256-vRpzOwM1KLwTa5NgvP1jw80fqG0gS3k446sRKzoHwNs=";
      };
      prefsFile = pkgs.writeText "HorlogeSkynet.user.js" (builtins.replaceStrings "user_pref" "defaultPref" (builtins.readFile "${baseConfig}/user.js"));
    in pkgs.thunderbird.override (old: {
      postInstall = (old.postInstall or "") ++ ''
        # Install arkenfox's user.js
        install -Dvm644 ${prefsFile} $out/lib/${binaryName}/browser/defaults/preferences/arkenfox.user.js
      '';
    });

    profiles = {
      "default" = {
        isDefault = true;
        withExternalGnupg = true;
      };
    };
  };
}
