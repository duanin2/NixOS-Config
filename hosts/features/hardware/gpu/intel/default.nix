{ inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-gpu-intel
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    };
  };
}