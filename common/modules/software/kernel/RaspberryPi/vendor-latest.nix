{ inputs, lib, pkgs, isoModules, ... }: {
	imports = [
	  (isoModules + /no-zfs.nix)
	];
	
	boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.callPackage "${inputs.rpi5}/linux-rpi.nix" (let
		modDirVersion = "6.11.0";
	in {
		argsOverride = {
			inherit modDirVersion;
			version = "${modDirVersion}-git";

			src = pkgs.fetchFromGitHub {
				owner = "raspberrypi";
				repo = "linux";
				rev = "8063035e26a3ab8b3640b59511e4600bf45b515e"; # Linux 6.11.0
				hash = "";
			};
		};

		kernelPatches = with pkgs.kernelPatches; [
			bridge_stp_helper
			request_key_helper
		];
		rpiVersion = 5;
	})));

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
}
