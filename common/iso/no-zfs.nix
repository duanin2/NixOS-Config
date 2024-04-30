{ lib, ... }: {
  boot.supportedFilesystems.zfs = lib.mkForce false;
}