{ lib, config, inputs, pkgs, persistDirectory, homeDirectory, ... }: let
  nativeGLFW = true;
in {
	home.packages = with pkgs; [
		/*
		(prismlauncher.override {
			prismlauncher-unwrapped = (prismlauncher-unwrapped.overrideAttrs (old: {
				patches = (old.patches or []) ++ [
					./allowOffline.patch
				];
			}));
		})
		*/
		prismlauncher
		kdePackages.kdialog
	];

  home.activation."PrismLauncherCFG" = let
    cfgPath = "${config.xdg.dataHome or "${homeDirectory}/.local/share"}/PrismLauncher/prismlauncher.cfg";
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
if [ -f "${cfgPath}" ]; then
	run ${lib.getExe pkgs.gnused} -i.bak -E -e "s/^UseNativeGLFW=(true|false)$/UseNativeGLFW=${builtins.toString nativeGLFW}/" -e "s|^CustomGLFWPath=.*$|CustomGLFWPath=${pkgs.glfw-wayland-minecraft}/lib/libglfw.so|" ${cfgPath}
fi
  '';

	home.persistence.${persistDirectory} = {
		directories = [ ".local/share/PrismLauncher" ];
	};
}
