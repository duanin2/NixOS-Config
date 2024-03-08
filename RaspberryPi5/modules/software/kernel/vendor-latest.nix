{ inputs, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage "${inputs.rpi5}/linux-rpi.nix" (let
    modDirVersion = "6.8-rc7";
  in {
    inherit modDirVersion;
    version = modDirVersion;

    src = pkgs.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "linux";
      rev = "d6d6c49dbf4512f1421f5e42896e2d70dc121f9a"; # 6.7.8
      hash = "";
    };

    kernelPatches = with pkgs.kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
    rpiVersion = 5;
  }));
}