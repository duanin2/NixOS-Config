{ lib, ... }: {
  imports = [
    # software
    ../modules/software/localization

    # software/network
    ../modules/software/network/networkmanager
    ../modules/software/network/resolvd

    # software/shell
    ../modules/software/shell/nushell.nix

    ./nixos
  ];

  /*
  boot.supportedFilesystems = [
    "btrfs"
    "bcachefs"
  ];
  */
  boot.supportedFilesystems = {
    btrfs = true;
    bchachefs = true;
  };

  boot.loader.efi.canTouchEfiVariables = false;

  system.stateVersion = "23.11";
}