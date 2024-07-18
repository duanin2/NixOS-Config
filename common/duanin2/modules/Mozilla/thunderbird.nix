{ customPkgs, pkgs, persistDirectory, ... }: {
	programs.thunderbird = {
		enable = true;
		package = pkgs.thunderbird;

    settings = settings = customPkgs.mozilla.addUserJsPrefs (pkgs.fetchurl {
			url = "https://raw.githubusercontent.com/HorlogeSkynet/thunderbird-user.js/master/user.js";
			hash = "sha256-Blf/dEQFcHYZg6ElwNB6+RSJ0UlnfvqVMTmI69OI50k=";
		}) // { };
		profiles = { };
	};

	home.persistence.${persistDirectory} = {
    directories = [ ".thunderbird" ];
  };
}
