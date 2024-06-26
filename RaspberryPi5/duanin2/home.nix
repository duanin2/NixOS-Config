{ config, ... }: let
	homeDirectory = config.home.homeDirectory or ("/home/${config.home.username or "duanin2"}");
	persistDirectory = "/persist" + homeDirectory;
in {
  imports = [
    ../../common/duanin2/modules/shell/nushell
		../../common/duanin2/modules/shell/prompts/starship
    ./modules/impermanence
    ../../common/duanin2/modules/tldr
  ];

  home.stateVersion = "23.11";

  _module.args = { inherit homeDirectory persistDirectory; };
}
