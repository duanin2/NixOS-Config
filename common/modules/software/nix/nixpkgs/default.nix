{ inputs, stagingPkgs, ... }: {
	nixpkgs = {
		config = {
			allowUnfree = true;
		};
		overlays = [
			(final: prev: {
				xz = stagingPkgs.xz.override { inherit (final) lib stdenv fetchurl writeScript testers; };
			})
		];
	};
}
