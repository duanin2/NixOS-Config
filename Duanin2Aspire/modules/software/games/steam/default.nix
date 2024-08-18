{ config, pkgs, ... }: {
  imports = [
    ../.
  ];

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = { } // (if !config.chaotic.mesa-git.enable then {
        "__NV_PRIME_RENDER_OFFLOAD" = "1";
        "__NV_PRIME_RENDER_OFFLOAD_PROVIDER" = "NVIDIA-G0";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        "__VK_LAYER_NV_optimus" = "NVIDIA_only";
      } else {
        "DRI_PRIME" = "1";
      });
    };
    protontricks = {
      enable = true;
    };
    extest.enable = true;

    extraPackages = with pkgs; [ ];
  };
}
