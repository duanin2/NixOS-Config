{ lib, ... }: {
  services.pulseaudio.enable = lib.mkForce false;
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
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main."monitor.libcamera" = "disabled";
          };
        };
      };
		};
	};
}
