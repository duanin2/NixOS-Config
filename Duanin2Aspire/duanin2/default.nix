{ pkgs, ... }: {
	imports = [
		./modules/keepassxc/system.nix
	];

	users.users."duanin2" = {
		isNormalUser = true;
		description = "Dušan Till";
		extraGroups = [
			"wheel"
		];
		shell = pkgs.nushell;
		hashedPassword = "$6$rV8uoibpyFCsEGpV$kOXwr0EtSeW2O4tOC8qDd78VsNiL.6j4xjPozjj06KEmJX2bFGIn/D12WmVw4SO2His0Cygjgxyehh3v3aLOB/";
	};

	home-manager.users."duanin2" = import ./home.nix;
}
