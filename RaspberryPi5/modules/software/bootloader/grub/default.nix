{ ... }: {
  boot.loader.grub = {
    enable = true;
    
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    configurationLimit = 5;
  };
}
