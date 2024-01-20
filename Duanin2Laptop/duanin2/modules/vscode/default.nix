{ pkgs, ... }: {
	programs.vscode = {
		enable = true;
		package = pkgs.vscodium;

		extensions = with pkgs.vscode-extensions; [
			catppuccin.catppuccin-vsc
			catppuccin.catppuccin-vsc-icons
			
			jnoortheen.nix-ide
			mkhl.direnv
		] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
				name = "vscode-nushell-lang";
				publisher = "TheNuProjectContributors";
				version = "1.8.0";
				sha256 = "4a2ecde74be89e91bbf653e29e019988d0198dea11278e4f0eea259d1f5af6d6";
			}
    ];
		mutableExtensionsDir = false;
	};

	home.packages = with pkgs; [
		nil
		nixpkgs-fmt
	];
}
