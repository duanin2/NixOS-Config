{ customPkgs, pkgs, persistDirectory, ... }: {
	programs.thunderbird = {
		enable = true;
		package = pkgs.thunderbird;

    settings = (customPkgs.mozilla.addUserJsPrefs (pkgs.fetchurl {
			url = "https://raw.githubusercontent.com/HorlogeSkynet/thunderbird-user.js/master/user.js";
			hash = "sha256-XRtG0iLKh8uqbeX7Rc2H6VJwZYJoNZPBlAfZEfrSCP4=";
		})).res // { };
		profiles = { };
	};

	home.persistence.${persistDirectory} = {
    directories = [ ".thunderbird" ];
  };
}
