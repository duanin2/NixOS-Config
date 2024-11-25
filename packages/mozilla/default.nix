{ callPackage, ... }: {
  addUserJsPrefs = src: callPackage ./addUserJsPrefs.nix { inherit src; };

  firefoxAddons = callPackage ./firefox-addons { };
}
