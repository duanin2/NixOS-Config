{ pkgs, ... }: {
	users.users.nixos = {
		description = "NixOS ISO User";
		shell = pkgs.nushell;
	};
}
