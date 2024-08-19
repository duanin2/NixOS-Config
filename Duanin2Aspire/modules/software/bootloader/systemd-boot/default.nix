{ modules, ... }: {
	imports = [
		(modules.local.hardware + /efi)
	];

	boot.loader.systemd-boot = {
		enable = true;

		configurationLimit = 5;
		editor = true;
	};
}
