{ modules, ... }: {
  imports = [
    (modules.common.software + /nix)
  ];

  nix.settings = {
    extra-platforms = [
      "armv7l-linux"
      "armv6l-linux"
    ];
  };
}