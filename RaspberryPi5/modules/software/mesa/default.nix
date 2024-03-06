{ pkgs, ... }: let
  override = {
    galliumDrivers = [
      "swrast"
      "virgl"
      "zink"
      "v3d"
    ];
    vulkanDrivers = [
      "swrast"
      "virtio"
      "broadcom"
    ];
  };
in {
  hardware.opengl = {
    enable = true;
    # driSupport32Bit = true;

    package = pkgs.mesa.override override;
  };
}