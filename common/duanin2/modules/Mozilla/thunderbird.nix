{ customPkgs, pkgs, persistDirectory, ... }: {
	programs.thunderbird = {
		enable = true;
		package = customPkgs.mozilla.addUserJsPrefs {
			package = pkgs.thunderbird;
			src = pkgs.fetchurl {
				url = "https://raw.githubusercontent.com/HorlogeSkynet/thunderbird-user.js/master/user.js";
				hash = "sha256-2M7EOosZI9cYgCkOMn+aoHDsRPOrZQn/TyrtbkjSqNE=";
			};
		};

		profiles = { };
	};

	home.persistence.${persistDirectory} = {
    directories = [ ".thunderbird" ];
  };
}