{ lib, config, pkgs, ... }: {
  hardware.graphics = {
    enable = lib.mkForce true;

    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
    extraPackages32 = with pkgs; [
      nvidia-vaapi-driver
    ];
  };
  chaotic.mesa-git.enable = lib.mkForce false;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    powerManagement = {
      enable = true;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = false;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
}
