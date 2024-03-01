{ ... }: let
	locale = "cs_CZ.UTF-8";
	keyboardLayout = "cz";
in {
	time.timeZone = "Europe/Prague";

	i18n.defaultLocale = locale;
	i18n.extraLocaleSettings = {
		LC_ADDRESS = locale;
		LC_IDENTIFICATION = locale;
		LC_MEASUREMENT = locale;
		LC_MONETARY = locale;
		LC_NAME = locale;
		LC_NUMERIC = locale;
		LC_PAPER = locale;
		LC_TELEPHONE = locale;
		LC_TIME = locale;
	};

	services.xserver.xkb = {
		layout = "cz";
		variant = "";
	};
	console.keyMap = "cz";
}
