{ pkgs, inputs, ... }: {
	programs.firefox = {
		enable = true;
		package = (pkgs.callPackage ./common.nix { }) {
			package = (inputs.mercury-nixpkgs.legacyPackages.${pkgs.system}.mercury-browser-bin.overrideAttrs (old: {
				inherit (pkgs) stdenv dpkg wrapGAppsHook alsa-lib browserpass bakubrow cairo cups dbus dbus-glib ffmpeg fontconfig freetype fx-cast-bridge glib glibc gnome-browser-connector gtk3 harfbuzz libcanberra libdbusmenu libdbusmenu-gtk3 libglvnd libjack2 libkrb5 libnotify libpulseaudio libva lyx mesa nspr nss opensc pango pciutils pipewire sndio speechd tridactyl-native udev uget-integrator vulkan-loader xdg-utils xorg;
				plasma5Packages = inputs.kde2nix.legacyPackages.${pkgs.system};
				simd = "AVX2";
			})).override (old: {
				buildInputs = (old.buildInputs or []) ++ (with pkgs; [
					keepassxc
				]);
			});
			src = pkgs.fetchurl {
				url = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
				hash = "sha256-H3Nk5sDxSElGRgK+cyQpVyjtlMF2Okxbstu9A+eJtGk=";
			};
		};

		profiles = {
		  "default" = {
				bookmarks = [
					{
						name = "The toolbar";
						toolbar = true;
						bookmarks = [
							{
								name = "kernel.org";
								url = "https://www.kernel.org";
							}
							{
								name = "tio.run";
								url = "https://tio.run";
							}
							{
								name = "r/Piracy Megathread";
								url = "https://rentry.org/megathread";
							}
						];
					}
				];
				extensions = with pkgs.nur.repos.rycee.firefox-addons; [
					ublock-origin
					skip-redirect
					plasma-integration
					stylus
					firefox-color
					keepassxc-browser
					canvasblocker
					firemonkey
					libredirect
					indie-wiki-buddy
					auto-tab-discard
					steam-database
					terms-of-service-didnt-read
					unpaywall
					wayback-machine
				];
				settings = {
					"widget.use-xdg-desktop-portal.file-picker" = 1;

					# Arkenfox overrides
					"browser.startup.page" = 3;
					"privacy.clearOnShutdown.history" = false;
					"webgl.disabled" = false;
				};
		  };
		};
	};
}