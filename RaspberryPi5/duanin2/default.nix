{ pkgs, ... }: {
	users.users.duanin2 = {
		isNormalUser = true;
		description = "Dušan Till";
		extraGroups = [
			"networkmanager"
			"wheel"
		];
		shell = pkgs.nushellFull;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtepAfiQJkST5QEaUFv+y3tuOsXig53eB++alzn198TsXswPEFQmEHT3/KuIXIirLnaPVu9/lvxsyj3kgb4xGskXnzyXMC4snKJIQRg+SujIL2aE3u3dhVqzkVqj8ECLqd2jzAtcC95AzUdFR6liI9lTQ9KM1nmzK/SggrUgJydEKQxJmgBE5SzJ9kVoncpW+xNtMghsDzvuOW/N1zKMR3tB12tew32nenMFrq0FyPcIU+ZEB6jiCwEqoQ64GQEo8APKNGGnpuZ2lAQMVwLLH0Vw/PK2jXgaW70fCivGn3E6E4wM2t009CFggV6A2haOymrhdVSy6aE1VHVQf9HPqJm+GMyETfhy1iqPNPmdmjOAqKIS5u2mTbaUYURI5wtYQbAqr/JUla9Hg90OMMoQreCSe74H54lW0ljPVijajc4txdCImX9MU/bWlwmnE3t9n1NBh15g9P+QRFwPIkCpaZ+qXWrotVj+NOvEavNiJouldS7iQ8LdWthjS/SFV9ey0= duanin2@Duanin2Aspire"
    ];
	};

	home-manager.users."duanin2" = import ./home.nix;
}