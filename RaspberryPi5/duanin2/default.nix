{ pkgs, ... }: {
	users.users.duanin2 = {
		isNormalUser = true;
		description = "Dušan Till";
		extraGroups = [
			"networkmanager"
			"wheel"
		];
		shell = pkgs.nushellFull;
	};

	home-manager.users."duanin2" = import ./home.nix;
}