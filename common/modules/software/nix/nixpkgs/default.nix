{ inputs, ... }: {
	nixpkgs = {
		config = {
			allowUnfree = true;
		};
		overlays = [
			(prev: final: {
				xz = prev.xz.override { inherit (final) lib stdenv fetchurl writeScript testers; };
			})
		];
	};
}
