{ callPackage, ... }: {
  addUserJsPrefs = opts: callPackage ./addUserJsPrefs.nix opts;

  firefoxAddons = callPackage ./firefox-addons { };
}
