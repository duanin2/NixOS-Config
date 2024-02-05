{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mangohud_git
    goverlay
  ];

  security.wrappers = {
    intel_gpu_top = {
      owner = "root";
      group = "root";
      source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
      capabilities = "cap_perfmon";
    };
  };
}