{ config, pkgs, modules', ... }: let
	homeDirectory = config.home.homeDirectory or ("/home/${config.home.username or "duanin2"}");
	persistDirectory = "/persist" + homeDirectory;

  modules = modules' // rec {
    local = {
      outPath = ./modules;

      games = local.outPath + /games;
    };
  };
in {
	imports = [
		(modules.local + /vscode)
		(modules.local + /syncthing)
		(modules.local + /keepassxc)
		(modules.local + /libreoffice)
		#(modules.local + /discord)
		(modules.local + /direnv)
		(modules.local + /xdg)
		(modules.local + /bash)
		(modules.local + /bottles)
		(modules.local + /git)
		(modules.local + /theming)
		#(modules.local + /alacritty)
		(modules.local + /ssh)
		(modules.local + /impermanence)
		#(modules.common + /Emacs)
		(modules.common + /tldr)
		#(modules.common + /eww)
		#(modules.common + /pidgin)
		(modules.common + /systemd)
		#(modules.common + /gnunet)
		(modules.common + /kdeConnect)
		(modules.common + /nix)

		#(modules.local + /Hyprland)
		(modules.local + /plasma)
    
		(modules.local.games + /prismlauncher)
		#(modules.local.games + /vinegar)
		(modules.local.games + /lutris)
		#(modules.local.games + /godot)
		(modules.local.games + /mangohud)
		(modules.local.games + "/osu!")

		(modules.common.shell + /nushell)
		(modules.common.shell.prompts + /starship)

		(modules.common.Mozilla + /firefox.nix)
		#(modules.common.Mozilla + /mullvad.nix)
		(modules.common.Mozilla + /thunderbird.nix)

		(modules.local + /mpv)
		(modules.local + /mpv/ani-cli.nix)
		(modules.local + /yt-dlp)
	];

	home.persistence.${persistDirectory} = {
    directories = [
      ".config/autostart"
    ];
  };

	home.stateVersion = "23.11";

	_module.args = { inherit homeDirectory persistDirectory modules; };
}
