{ pkgs, ... }: {
	networking.networkmanager = {
		enable = true;

		dns = "systemd-resolved";
	};

	networking.wireless.extraConfig = ''
openssl_ciphers=DEFAULT@SECLEVEL=0
	'';

	systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
openssl_conf = openssl_init
[openssl_init]
ssl_conf = ssl_sect
[ssl_sect]
system_default = system_default_sect
[system_default_sect]
Options = UnsafeLegacyRenegotiation
[system_default_sect]
CipherString = Default:@SECLEVEL=0
	'';

	users.users."duanin2".extraGroups = [ "networkmanager" ];
}
