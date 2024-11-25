{ lib, config, pkgs, modules, ... }: {
  disabledModules = [ (modules.local.software + /tlp) ];
  
  imports = [
    (modules.local.software + /X)
    ./plasma6.nix
    (modules.common.software + /kdeConnect)
  ];

  environment.systemPackages = with pkgs; [
    (catppuccin-gtk.override {
			variant = "frappe";
			accents = [ "green" ];
		})
		catppuccin-cursors.frappeGreen
		(catppuccin-papirus-folders.override {
			flavor = "frappe";
			accent = "green";
		})

    clinfo
		mesa-demos
		vulkan-tools
		wayland-utils
		pciutils

		(catppuccin-kde.override {
			flavour = [ "frappe" ];
			accents = [ "green" ];
		})

		lightly-qt
  ];

	programs.dconf.enable = true;
	services.fwupd.enable = true;
	chaotic.appmenu-gtk3-module.enable = true;

	programs.gnupg.agent.pinentryPackage = if config.programs.gnupg.agent.enable then pkgs.pinentry-qt else config.programs.gnupg.agent.pinentryPackage;
}
