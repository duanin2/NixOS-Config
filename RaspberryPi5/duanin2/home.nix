{ config, modules', ... }: let
	homeDirectory = config.home.homeDirectory or ("/home/${config.home.username or "duanin2"}");
	persistDirectory = "/persist" + homeDirectory;

  modules = modules' // {
    local.outPath = ./modules;
  };
in {
  imports = [
    (modules.common.shell.prompts + /nushell)
		(modules.common.shell.prompts + /starship)
    (modules.local + /impermanence)
    (modules.common + /tldr)
  ];

  home.stateVersion = "23.11";

  _module.args = { inherit homeDirectory persistDirectory modules; };
}
