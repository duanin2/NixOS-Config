{ ... }: {
  imports = [
    ./rpi5.nix
  ];

  programs.ssh = {
    enable = true;

    compression = true;
  };
}
