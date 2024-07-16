{ callPackage, ... }: {
  librejs = callPackage ./librejs.nix { };
  firefoxpwa = callPackage ./firefoxpwa.nix { };
}
