{ pkgs, ... }: {
	programs.thunderbird = {
		enable = true;
		package = (pkgs.callPackage ./common.nix { }) {
			package = pkgs.thunderbird;
			src = pkgs.fetchurl {
				url = "https://raw.githubusercontent.com/HorlogeSkynet/thunderbird-user.js/master/user.js";
				hash = "sha256-66B1yLQkQnydAUXD7KGt32OhWSYcdWX+BUozrgW9uAg=";
			};
		};

		profiles = {};
	};
}