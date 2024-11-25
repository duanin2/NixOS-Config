{ inputs, pkgs, ... }: let 
	hyprland = inputs.hyprland.packages.${pkgs.system};
in {
	programs.hyprland = {
		enable = true;
		package = hyprland.hyprland;
		portalPackage = hyprland.xdg-desktop-portal-hyprland;
	};
}
