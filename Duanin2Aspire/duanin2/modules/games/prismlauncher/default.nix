{ inputs, pkgs, persistDirectory, ... }: {
	imports = [
		../.
	];

	home.packages = with pkgs; [
		(prismlauncher.override {
			prismlauncher-unwrapped = (prismlauncher-unwrapped.overrideAttrs (old: {
				version = "8.3";
				patches = (old.patches or []) ++ [
					./allowOffline.patch
				];
			}));
		})
		kdialog
	];

	home.persistence.${persistDirectory} = {
		directories = [ ".local/share/PrismLauncher" ];
	};
}
