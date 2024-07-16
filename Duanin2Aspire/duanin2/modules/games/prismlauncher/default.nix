{ lib, config, inputs, pkgs, persistDirectory, homeDirectory, ... }: let
  nativeGLFW = true;
in {
	imports = [
		../.
	];

	home.packages = with pkgs; [
		(prismlauncher.override {
			prismlauncher-unwrapped = (prismlauncher-unwrapped.overrideAttrs (old: {
				patches = (old.patches or []) ++ [
					./allowOffline.patch
				];
			}));
		})
		kdialog
	];

  home.activation."PrismLauncherCFG" = let
    cfgPath = "${config.xdg.dataHome or "${homeDirectory}/.local/share"}/PrismLauncher/prismlauncher.cfg";
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
CFG=$(cat ${cfgPath})

CFG=$(echo $CFG | sed -E -e "s/^UseNativeGLFW=(true|false)$/UseNativeGLFW=${builtins.toString nativeGLFW}/" -e $"s|^CustomGLFWPath=.*$|CustomGLFWPath=${if nativeGLFW then "${pkgs.glfw-wayland-minecraft}/lib/libglfw.so" else ""}|")

echo "$CFG" | run tee ${cfgPath}
  '';

	home.persistence.${persistDirectory} = {
		directories = [ ".local/share/PrismLauncher" ];
	};
}
