{ persistDirectory, ... }: {
  imports = [
    ./rpi5.nix
    ./github.nix
  ];

  programs.ssh = {
    enable = true;

    compression = true;
  };

  home.persistence.${persistDirectory} = {
    directories = [ ".ssh" ];
  };
}
