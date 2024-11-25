{ pkgs, ... }: let
  baseExtraPackages = pkgs': extraPackages: with pkgs'; [
    intel-media-driver
    vaapi-intel-hybrid
    
    vaapiIntel
    libvdpau-va-gl
  ] ++ extraPackages;
in {
  boot.kernelParams = [
    "i915.enable_psr=0"
  ];

  hardware.graphics = {
    extraPackages = baseExtraPackages pkgs (with pkgs; [
      intel-compute-runtime

      intel-media-sdk
    ]);
    extraPackages32 = baseExtraPackages pkgs.pkgsi686Linux [];
  };
  chaotic.mesa-git = {
    extraPackages = baseExtraPackages pkgs (with pkgs; [
      intel-compute-runtime

      intel-media-sdk
    ]);
    extraPackages32 = baseExtraPackages pkgs.pkgsi686Linux [];
  };
}
