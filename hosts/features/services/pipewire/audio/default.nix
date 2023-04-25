{ ... }: {
  imports = [
    ./alsa.nix
    ./jack.nix
    ./pulse.nix
    ./..
  ];
}