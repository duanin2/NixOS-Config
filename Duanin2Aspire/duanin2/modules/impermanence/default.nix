{ lib, config, inputs, pkgs, persistDirectory, ... }: let
  godot_4-mono = pkgs.callPackage (inputs.godot-nixpkgs + "/pkgs/development/tools/godot/4/mono/default.nix") { };
in {
  home.persistence.${persistDirectory} = {
    directories = [
      "Dokumenty"
      "Hudba"
      "KeePass"
      "Obrázky"
      "Plocha"
      "Stažené"
      "Veřejné"
      "Videa"
      "Šablony"
      "Hry"
      "dev"
      ".android"
      ".gnupg"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    allowOther = true;
  };
}