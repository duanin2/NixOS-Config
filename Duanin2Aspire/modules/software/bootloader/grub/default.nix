{ modules, lib, ... }: {
  imports = [
    (modules.local.hardware + /efi)
  ];

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  boot.loader.grub = {
    enable = true;
    
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    configurationLimit = 5;

    enableCryptodisk = true;
  };
}
