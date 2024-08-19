{ modules, ... }: {
  imports = [
    # software
    (modules.common.software + /localization)

    # software/network
    (modules.common.software.network + /networkmanager)
    (modules.common.software.network + /resolvd)

    # software/shell
    (modules.common.software.shell + /nushell.nix)

    ./nixos
  ];
  
  boot.supportedFilesystems = {
    btrfs = true;
    bchachefs = true;
  };

  boot.loader.efi.canTouchEfiVariables = false;

  system.stateVersion = "23.11";
}
