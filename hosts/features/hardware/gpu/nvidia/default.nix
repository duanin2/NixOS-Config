{ inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-gpu-nvidia
  ];

  hardware.nvidia.modesetting.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
}