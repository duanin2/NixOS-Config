{ lib, ... }: {
	imports = [
		./..
	];

	hardware.pulseaudio.enable = lib.mkForce false;
	security.rtkit.enable = true;

	services.pipewire = {
		enable = true;
		audio.enable = true;

		alsa = {
			enable = true;

			support32Bit = true;
		};
		jack.enable = true;
		pulse.enable = true;
		wireplumber = {
			enable = true;
		};
	};
}
