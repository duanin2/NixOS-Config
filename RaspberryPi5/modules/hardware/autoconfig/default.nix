# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/RootFS";
    fsType = "btrfs";
    options =  [
      "compress-force=zstd:4"
    ];
    neededForBoot = true;
  };

  fileSystems."/nix" =
    { device = "/persist/nix";
			depends = [ "/persist" ];
      fsType = "none";
      neededForBoot = true;
      options = [ "bind" ];
    };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=3G"
      "mode=755"
    ];
  };

  fileSystems."/home/duanin2" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=3G"
      "mode=755"
    ];
  };
  
  fileSystems."/tmp" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=80%"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-uuid/12EF-1B5C";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
