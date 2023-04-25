{ inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
  ];
}