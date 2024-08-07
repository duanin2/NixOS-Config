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
		];
    hashedPassword = "$y$j9T$TPAb8CeEe5XGds2FQ4bIL1$fg5EP5iH4w2phzm3cNnRRrFK/K9tJLOaRc93bWAGJiA";
	};

	home-manager.users."duanin2" = import ./home.nix;
}
