{ ... }: {
	nixpkgs = {
		config = {
			allowUnfree = true;
		};
	};
}