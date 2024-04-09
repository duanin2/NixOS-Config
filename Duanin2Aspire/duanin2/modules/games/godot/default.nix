{ inputs, pkgs, persistDirectory, ... }: let
  godot_4-mono = pkgs.callPackage (inputs.godot-nixpkgs + "/pkgs/development/tools/godot/4/mono/default.nix") { };
in {
  home.packages = with pkgs; [
    godot_4-mono
    dotnet-sdk
  ];

  home.persistence.${persistDirectory} = {
    directories = [ ".local/share/godot" ];
  };
} 