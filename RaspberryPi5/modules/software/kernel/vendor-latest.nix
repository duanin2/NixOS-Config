{ inputs, lib, pkgs, ... }: {
  imports = [
    ../../../../common/iso/no-zfs.nix
  ];
  
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.callPackage "${inputs.rpi5}/linux-rpi.nix" (let
    modDirVersion = "6.8.5";
  in {
    inherit modDirVersion;
    version = modDirVersion;

    src = pkgs.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "linux";
      rev = "b95f2066a910ace64787dc4f3e1dfcb2e7e71718"; # Linux 6.8.5
      hash = "";
    };

    kernelPatches = with pkgs.kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
    rpiVersion = 5;
  })));
}