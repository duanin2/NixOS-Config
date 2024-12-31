{ pkgs, ... }: {
	users.users."duanin2" = {
		isNormalUser = true;
		description = "Dušan Till";
		extraGroups = [
			"wheel"
		];
		shell = pkgs.nushell;
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZk0KsH40cx78qXF/KvNliHxaGaTDJZMAkUrbP539Hf duanin2@Duanin2Aspire"
			"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDec4MYtznc8VGodk4ph4F6c/Jp+k6bmw47EUDXtHB8ghtVTxT7ksxs6mJ+uaqulbrYRSSxCdubdLT0Ap38FLyiTFR8cmIR4nUiGkEDfFBMh5o0ZU1FUrV4LOBbycexK0rrWkddkv+wpC+LgF4D2no3ePf27pImS61HvlXA7gSvMkc8zbMFP5uMJsGJLAhZz1X2YLFUFok/9+l8sOqwzxkMD/SMWuRjUeAEyF5XdNllnl9NX163m/IKE/XXQXG31SnJQ8MKPjPjqR3dEVa0P8OWXcFZW0wMFva/MEcu7CdVc4+2hUhm/U1jIgvKUrJtdpQMfiEizZ02SXh66W1mRnbz rpi5"
			"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCaj4IJZO206huWfHnx7V6Uny22A2ERbDtAgolA07951mkvMaEGJvzcIPjEq78+qMiCnoz1TdCesk9atbO7BkhZz58wvwJZ/7hKuOk8xwkHja26dDKmHHdxIa8BklHJx5TLcs+XNF1KZmjICy87c03Waz2d2BbbF2E8JhsvA/ewsURTrFq9faKll1WCizQfYjAKvyl6ZxmP/om1PzjJuFuolYbffWBEY7I7hNc2h2+KMP+4LkzEg5r0M3XLEgc9vEhzTNGGIM5weyWq5N7TMf1pmDs+z7avsBeYE9dpv0vNbKOcYgLikAC5NM6mKmJdS8hIukT+Ec5e0f6QpIDO7Kx29stQ7Ph4dTXEkrjeHtSGEYGXRyvonIR9vBVWGxdY3BLUUyCmOTPjHJv06ktaQmxbtcPKEl99SvxCqxLQ8mtJxe0BY0bt/Y8QwRyrwbDMRsqljSiAQNOWpVUAqSq7v69TKYkAuwWd3dueyYVJHd7urBNwazIDcAeEjS9swhnFuUbc02zR/gNcmBiKegy+6QRF9al113yVRWUW42pwhFjKplFeM1BH1vtJurWxnFxhd05R1CRul8y4OnDsleOIFyb+g9iTsyp4XDNGZ8p0tVqKbaxk8DxH1lrd1YBEmyVKdLM5jQY3qEIASvZQP3CjQyepjTI3JnO1VVgWZxWpbLEa/Q== openpgp:0x0F9715DF"
		];
    hashedPassword = "$y$j9T$TPAb8CeEe5XGds2FQ4bIL1$fg5EP5iH4w2phzm3cNnRRrFK/K9tJLOaRc93bWAGJiA";
	};

	home-manager.users."duanin2" = import ./home.nix;
}
