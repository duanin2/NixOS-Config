{ pkgs, ... }: {
	imports = [
		./modules/vscode
		./modules/syncthing
		./modules/keepassxc
		./modules/libreoffice
		./modules/discord
		./modules/direnv
		./modules/xdg
		./modules/bash
		./modules/bottles
		./modules/git

		./modules/games/prismlauncher
		# ./modules/games/vinegar
		./modules/games/lutris
		./modules/games/godot

		./modules/shell/nushell.nix
		./modules/shell/starship

		./modules/Mozilla/firefox.nix
		./modules/Mozilla/thunderbird.nix

		./modules/mpv
		./modules/mpv/ani-cli.nix
	];

	home.packages = with pkgs; [
		telegram-desktop
	];

	home.stateVersion = "24.05";
}
