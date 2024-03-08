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

		../../common/duanin2/modules/shell/nushell.nix
		../../common/duanin2/modules/shell/starship

		../../common/duanin2/modules/Mozilla/firefox.nix
		../../common/duanin2/modules/Mozilla/thunderbird.nix

		./modules/mpv
		./modules/mpv/ani-cli.nix
	];

	home.packages = with pkgs; [
		telegram-desktop
		transmission-qt
	];

	home.stateVersion = "24.05";
}
