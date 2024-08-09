{ pkgs, lib, ... }: {
  hardware = {
    enableRedistributableFirmware = lib.mkForce true;
    firmware = [ pkgs.wireless-regdb ];
  };
  boot = {
    extraModprobeConfig = ''
options cfg80211 ieee80211_regdom="CZ"
    '';
    kernelParams = [
      "brcmfmac.feature_disable=0x82000"
    ];
  };
}
