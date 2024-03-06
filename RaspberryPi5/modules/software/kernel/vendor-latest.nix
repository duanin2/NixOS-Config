{ inputs, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage "${inputs.rpi5}/linux-rpi.nix" (let
    modDirVersion = "6.8-rc7";
  in {
    inherit modDirVersion;
    version = modDirVersion;

    src = pkgs.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "linux";
      rev = "90d35da658da8cff0d4ecbb5113f5fac9d00eb72";
      hash = "sha256-wPsC8/cUscTbBrgxYu2Y2h0qdr8a0BbJqvl3avbTMWE=";
    };

    kernelPatches = with pkgs.kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
    rpiVersion = 5;
  }));
}