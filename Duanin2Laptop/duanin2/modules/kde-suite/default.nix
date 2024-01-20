{ pkgs, ... }: {
	home.packages = with pkgs; [
		kmail
	];
}
