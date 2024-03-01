{ inputs, pkgs, ... }: {
  imports = [
    ../.
  ];

  home.packages = with pkgs; [
    (prismlauncher.override {
      prismlauncher-unwrapped = (prismlauncher-unwrapped.overrideAttrs (old: {
        version = "8.0";
        patches = (old.patches or []) ++ [
          (pkgs.fetchpatch {
            url = "https://github.com/duanin2/PKGBUILD/raw/main/prismlauncher-cracked/allowOffline.patch";
            hash = "sha256-3iO0AUHmS297CJOXTDpKFPBVhz8TpnbfmIBJ3Aa7MZQ=";
          })
        ];
      }));
    })
    kdialog
  ];
}