{ inputs, ... }: {
	nixpkgs = {
		config = {
			allowUnfree = true;
		};
		overlays = [
			/*
			(final: prev: {
				invidious = prev.invidious.overrideAttrs (_oldAttrs: {
					src = prev.fetchFromGitHub {
						owner = "iv-org";
						repo = "invidious";
						fetchSubmodules = true;
						rev = "08390acd0c17875fddb84cabba54197a5b5740e4";
						sha256 = "sha256-75C/ImX/PYikVdSO4rZM/aYyEgx6pU90BHNeRFfcsDM=";
					};
				});
			})
			*/
		];
	};
}
