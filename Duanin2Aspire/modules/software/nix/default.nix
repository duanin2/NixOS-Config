{ lib, modules, ... }: {
	imports = [
		(modules.common.software + /nix)

		./nixpkgs
	];

	nix = {
		settings = {
			system-features = [
				"gccarch-x86-64-v3"
				"gccarch-x86-64-v2"
				"gccarch-x86-64-v1"
				"gccarch-skylake"

        "kvm"
        "nixos-test"
        "big-parallel"
			];

			cores = lib.mkForce 2;
		};
	};
}
