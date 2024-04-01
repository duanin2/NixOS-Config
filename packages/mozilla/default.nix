{ callPackage, ... }: {
  addUserJsPrefs = opts: callPackage (import ./addUserJsPrefs.nix opts) { };

  firefoxAddons = callPackage ./firefox-addons { };
}
