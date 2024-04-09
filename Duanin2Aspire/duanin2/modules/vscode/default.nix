{ config, pkgs, ... }: {
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
		userSettings = {
			"workbench.colorTheme" = "Catppuccin Frappé";
			"workbench.iconTheme" = "catppuccin-frappe";
			"editor.fontFamily" = "Fira Code Nerd Fonts Mono";
			"editor.tabSize" = 2;
			"editor.multiCursorModifier" = "ctrlCmd";
			"editor.insertSpaces" = false;
			"editor.wordWrap" = "on";
			"editor.fontLigatures" = true;
			"editor.fontWeight" = "normal";
			"catppuccin.accentColor" = "green";
			"direnv.restart.automatic" = true;
			"nix.enableLanguageServer" = true;
			"nix.serverSettings" = {
				"nil" = {
					"diagnostics" = {
						"ignored" = [ "unused_binding" "unused_with" ];
					};
					"formatting" = {
						"command" = [ pkgs.nixpkgs-fmt ];
					};
					"nix" = {
						"flake" = {
							"autoArchive" = true;
							"autoEvalInputs" = true;
						};
					};
				};
			};
			"nix.serverPath" = pkgs.nil;
			"nushellLanguageServer.nushellExecutablePath" = config.programs.nushell.package;
		};
	};

	/*
	home.packages = with pkgs; [
		nil
		nixpkgs-fmt
	];
	*/
}
