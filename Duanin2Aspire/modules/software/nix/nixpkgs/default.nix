{ modules, customPkgs, ... }: {
	imports = [
		(modules.common.software + /nix/nixpkgs)
	];

	nixpkgs = {
		overlays = [ ];
		config.permittedInsecurePackages = [
			"electron-31.7.7"
		];
	};
}
