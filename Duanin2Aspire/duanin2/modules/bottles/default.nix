{ pkgs, persistDirectory, ... }: {
  home.packages = with pkgs; [
    bottles
  ];

  home.persistence.${persistDirectory} = {
    directories = [ ".local/share/bottles" ];
  };
}