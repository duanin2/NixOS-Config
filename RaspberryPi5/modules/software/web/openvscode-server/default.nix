{ ... }: {
	services.openvscode-server = {
		enable = true;

		telemetryLevel = "off";
		withoutConnectionToken = true;
		port = 5000; # Remember to forward port 5000 on SSH
	};
}