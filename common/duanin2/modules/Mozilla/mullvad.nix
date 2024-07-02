{ lib, config, nur, customPkgs, pkgs, inputs, persistDirectory, ... }: {
  disabledModules = [ ./firefox.nix ];

  programs.librewolf = {
    enable = true;
    package = pkgs.mullvad-browser;

    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };

	home.persistence.${persistDirectory} = {
    directories = [ ".mullvad" ];
  };
}
