{ pkgs, lib, ... }: {
	boot.loader.efi = {
		canTouchEfiVariables = lib.mkDefault true;
		efiSysMountPoint = "/efi";
	};
}
