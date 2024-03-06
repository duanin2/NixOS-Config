{ pkgs, ... }: let
  override = (old: {
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
  });
  overrideAttrs = (old: {
    mesonFlags = (old.mesonFlags or []) ++ [
      "-Dgallium-vdpau=disabled"
      "-Dgallium-va=disabled"
      "-Dgallium-xa=disabled"
    ];
  });
in {
  hardware.opengl = {
    enable = true;
    # driSupport32Bit = true;

    package = (pkgs.mesa.override override).overrideAttrs overrideAttrs;
  };
}