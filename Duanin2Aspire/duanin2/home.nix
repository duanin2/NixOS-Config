{ config, pkgs, ... }: let
	homeDirectory = config.home.homeDirectory or ("/home/${config.home.username or "duanin2"}");
	persistDirectory = "/persist" + homeDirectory;
in {
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
		./modules/Hyprland
		./modules/theming
		./modules/alacritty
		./modules/ssh
		./modules/impermanence

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

	home.stateVersion = "23.11";

	_module.args = { inherit homeDirectory persistDirectory; };
}
