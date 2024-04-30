{ config, ... }: let
	homeDirectory = config.home.homeDirectory or ("/home/${config.home.username or "duanin2"}");
	persistDirectory = "/persist" + homeDirectory;
in {
  imports = [
    ../../common/duanin2/modules/shell/nushell.nix
		../../common/duanin2/modules/shell/starship
    ./modules/impermanence
  ];

  home.stateVersion = "23.11";

  _module.args = { inherit homeDirectory persistDirectory; };
}
