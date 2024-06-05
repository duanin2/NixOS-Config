{ persistDirectory, ... }: {
	services.syncthing = {
		enable = true;
	};

  home.persistence.${persistDirectory}.directories = [ "/home/duanin2/.local/state/syncthing" ];
}
