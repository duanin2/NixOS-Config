{ inputs, lib, pkgs, ... }: {
	imports = [
	  ../../../../common/iso/no-zfs.nix
	];
	
	boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.callPackage "${inputs.rpi5}/linux-rpi.nix" (let
		modDirVersion = "6.8.7";
	in {
		argsOverride = {
			inherit modDirVersion;
			version = "${modDirVersion}-git";

			src = pkgs.fetchFromGitHub {
				owner = "raspberrypi";
				repo = "linux";
				rev = "12dadc409c2bd8538c6ee0e56e191efde6d92007"; # Linux 6.8.7
				hash = "sha256-eqterW9A+opVmUvDGCNLBV3I2Vpf1DAE4+RHn6VxGMg=";
			};
		};

		kernelPatches = with pkgs.kernelPatches; [
			bridge_stp_helper
			request_key_helper
		];
		rpiVersion = 5;
	})));
}