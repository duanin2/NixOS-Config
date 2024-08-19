{ lib, config, pkgs, modules, ... }: {
  imports = [
    (modules.local + /X)
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

	programs.gnupg.agent.pinentryPackage = if config.programs.gnupg.enable then pkgs.pinetry-qt else config.programs.gnupg.agent.pinentryPackage;
}
