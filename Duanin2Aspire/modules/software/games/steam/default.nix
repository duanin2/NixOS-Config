{ pkgs, ... }: {
  imports = [
    ../.
  ];

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        "DRI_PRIME" = "1";
      };
    };
  };
}