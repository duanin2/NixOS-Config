{ config, ... }: {
  enable = true;

  homedir = "${config.xdg.dataHome}/gnupg";
  mutableKeys = true;
  mutableTrust = true;
}
