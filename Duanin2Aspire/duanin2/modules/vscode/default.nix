{ lib, config, pkgs, ... }: {
	programs.vscode = {
		enable = true;
		package = pkgs.vscodium;

		extensions = with pkgs.vscode-extensions; [
			catppuccin.catppuccin-vsc
			catppuccin.catppuccin-vsc-icons
			
			jnoortheen.nix-ide
			mkhl.direnv

			thenuprojectcontributors.vscode-nushell-lang
		] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];
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
						"command" = [ (lib.getExe pkgs.nixpkgs-fmt) ];
					};
					"nix" = {
						"flake" = {
							"autoArchive" = true;
						};
					};
				};
			};
			"nix.serverPath" = (lib.getExe pkgs.nil);
			"nushellLanguageServer.nushellExecutablePath" = lib.getExe config.programs.nushell.package;
		};
	};
}
