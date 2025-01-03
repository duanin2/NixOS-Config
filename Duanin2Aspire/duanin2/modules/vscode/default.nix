{ lib, config, pkgs, ... }: {
	programs.vscode = {
		enable = true;
		package = pkgs.vscodium;

		extensions = with pkgs.vscode-extensions; [
			catppuccin.catppuccin-vsc
			catppuccin.catppuccin-vsc-icons

			mkhl.direnv
			# wakatime.vscode-wakatime
			leonardssh.vscord
			
			jnoortheen.nix-ide

			thenuprojectcontributors.vscode-nushell-lang
		] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];
		mutableExtensionsDir = false;
		userSettings = {
			"workbench.colorTheme" = "Catppuccin Frappé";
			"workbench.iconTheme" = "catppuccin-frappe";
			"catppuccin.accentColor" = "green";

			"editor.fontFamily" = "Fira Code Nerd Fonts Mono";
			"editor.fontLigatures" = true;
			"editor.fontWeight" = "normal";
			"editor.fontSize" = 11;

			"editor.tabSize" = 2;
			"editor.insertSpaces" = false;
			"editor.detectIndentation" = true;

			"editor.multiCursorModifier" = "ctrlCmd";
			"editor.wordWrap" = "on";

			"files.autoSave" = "onFocusChange";

			"git.autofetch" = true;
			"git.autofetchPeriod" = 300;
			#"git.enableCommitSigning" = true;
			"git.enableSmartCommit" = true;
			"git.mergeEditor" = true;
			"git.terminalGitEditor" = true;
			"github.gitProtocol" = "ssh";
			"merge-conflict.autoNavigateNextConflict.enabled" = true;

			"direnv.restart.automatic" = true;

			"vscord.status.image.large.debugging.key" = "https://vscord.catppuccin.com/frappe/debugging.webp";
			"vscord.status.image.large.editing.key" = "https://vscord.catppuccin.com/frappe/{lang}.webp";
			"vscord.status.image.large.idle.key" = "https://vscord.catppuccin.com/frappe/idle-{app_id}.webp";
			"vscord.status.image.large.notInFile.key" = "https://vscord.catppuccin.com/frappe/idle-{app_id}.webp";
			"vscord.status.image.large.viewing.key" = "https://vscord.catppuccin.com/frappe/{lang}.webp";
			"vscord.status.image.small.debugging.key" = "https://vscord.catppuccin.com/frappe/debugging.webp";
			"vscord.status.image.small.editing.key" = "https://vscord.catppuccin.com/frappe/{app_id}.webp";
			"vscord.status.image.small.idle.key" = "https://vscord.catppuccin.com/frappe/idle.webp";
			"vscord.status.image.small.notInFile.key" = "https://vscord.catppuccin.com/frappe/idle.webp";
			"vscord.status.image.small.viewing.key" = "https://vscord.catppuccin.com/frappe/{app_id}.webp";

			"nix.enableLanguageServer" = true;
			"nix.serverPath" = (lib.getExe pkgs.nil);
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

			"nushellLanguageServer.nushellExecutablePath" = lib.getExe config.programs.nushell.package;

			"php.validate.executablePath" = lib.getExe pkgs.php;

			"javascript.inlayHints.enumMemberValues.enabled" = true;
			"javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
			"javascript.inlayHints.parameterNames.enabled" = "all";
			"javascript.inlayHints.parameterTypes.enabled" = true;
			"javascript.inlayHints.propertyDeclarationTypes.enabled" = true;
			"javascript.inlayHints.variableTypes.enabled" = true;
			"javascript.preferences.importModuleSpecifier" = "projectRelative";
			"javascript.preferGoToSourceDefinition" = true;
			"typescript.inlayHints.enumMemberValues.enabled" = true;
			"typescript.inlayHints.functionLikeReturnTypes.enabled" = true;
			"typescript.inlayHints.parameterNames.enabled" = "all";
			"typescript.inlayHints.parameterTypes.enabled" = true;
			"typescript.inlayHints.propertyDeclarationTypes.enabled" = true;
			"typescript.inlayHints.variableTypes.enabled" = true;
			"typescript.npm" = "${pkgs.nodejs_22}/bin/npm";
			"typescript.preferences.importModuleSpecifier" = "projectRelative";
			"typescript.preferGoToSourceDefinition" = true;
			"typescript.tsdk" = "${pkgs.typescript}/lib/node_modules/typescript/lib";
			"typescript.tsserver.nodePath" = lib.getExe pkgs.nodejs_22;
			"typescript.tsserver.useSyntaxServer" = "never";
		};
	};
}
