{ pkgs, lib, ... }: {
	imports = [
		../../../hardware/efi
	];

	boot.loader.systemd-boot = {
		enable = true;

		configurationLimit = 100;
		editor = true;
	};
}
