{ ... }: {
  imports = [
    ../../common/duanin2/modules/shell/nushell.nix
		../../common/duanin2/modules/shell/starship
    ./modules/impermanence
  ];

  home.stateVersion = "23.11";
}
