{ pkgs, ... }: {
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope_git;
    capSysNice = true;

    env = {
      "__NV_PRIME_RENDER_OFFLOAD" = "1";
      "__NV_PRIME_RENDER_OFFLOAD_PROVIDER" = "NVIDIA-G0";
      "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      "__VK_LAYER_NV_optimus" = "NVIDIA_only";
    };
    args = [
      "--mangoapp"
      "--force-windows-fullscreen"
      "--rt"
      "--expose-wayland"
      "-F fsr"
      "-S auto"
    ];
  };
}
