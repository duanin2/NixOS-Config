{ inputs, ... }: {
	nixpkgs = {
		config = {
			allowUnfree = true;
		};
		overlays = [
			/*(final: prev: {
				xz = prev.xz.override { inherit (final) lib stdenv fetchurl writeScript testers; };
			})*/
		];
	};
}