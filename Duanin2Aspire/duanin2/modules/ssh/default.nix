{ ... }: {
  imports = [
    ./rpi5.nix
  ];

  programs.ssh = {
    enable = true;

    addKeysToAgent = "yes";
    compression = true;
  };
}