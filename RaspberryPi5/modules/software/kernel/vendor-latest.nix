{ inputs, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackagesFor (inputs.rpi5.legacyPackages.${pkgs.system}.linux_rpi5.overrideDerivation (old: let
    modDirVersion = "6.8-rc7";
  in {
    inherit modDirVersion;
    version = modDirVersion;

    src = pkgs.fetchFromGitHub {
      owner = old.src.owner;
      repo = old.src.repo;
      rev = "90d35da658da8cff0d4ecbb5113f5fac9d00eb72";
      hash = "sha256-wPsC8/cUscTbBrgxYu2Y2h0qdr8a0BbJqvl3avbTMWE=";
    };
  }));
}