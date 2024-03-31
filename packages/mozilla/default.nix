{ callPackage, ... }: {
  addUserJsPrefs = opts: callPackage (import ./addUserJs.nix opts) { };

  firefoxAddons = callPackage ./firefox-addons { };
}