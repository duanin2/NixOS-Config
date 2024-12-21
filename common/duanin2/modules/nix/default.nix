{ persistDirectory, ... }: {
  home.persistence.${persistDirectory}.directories = [
    ".cache/nix"
  ];
}