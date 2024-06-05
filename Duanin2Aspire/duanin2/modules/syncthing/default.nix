{ persistDirectory, ... }: {
	services.syncthing = {
		enable = true;
	};

  home.persistence.${persistDirectory}.directories = [ ".local/state/syncthing" ];
}
