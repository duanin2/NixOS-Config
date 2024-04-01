{ ... }: {
	nixpkgs = {
		overlays = [
			(final: prev: let
				getCustomMesa = (mesa: mesa.override (old: {
					galliumDrivers = [
						"nouveau"
						"swrast"
						"iris"
					];
					vulkanDrivers = [
						"nouveau-experimental"
						"swrast"
						"intel"
					];
				}));
			in builtins.mapAttrs (name: value: getCustomMesa value) { inherit (prev) mesa_git mesa32_git; })
		];
	};
}
