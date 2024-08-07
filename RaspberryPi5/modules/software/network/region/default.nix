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
      "brcmfmac.feature_disbale=0x8200"
    ];
  };
}
