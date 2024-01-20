{ pkgs, inputs, ... }: {
	environment.systemPackages = [ inputs.alejandra.defaultPackage.${pkgs.system} ];
}