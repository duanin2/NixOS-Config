{ modules, customPkgs, ... }: {
	imports = [
		(modules.common.software + /nix/nixpkgs)
	];

	nixpkgs = {
		overlays = [ ];
	};
}
