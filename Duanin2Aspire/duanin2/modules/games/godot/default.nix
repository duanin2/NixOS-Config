{ pkgs, persistDirectory, ... }: {
  home.packages = with pkgs; [
    godot_4-mono
    dotnet-sdk
  ];

  home.persistence.${persistDirectory} = {
    directories = [ ".local/share/godot" ];
  };
} 
