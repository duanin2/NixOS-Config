{ pkgs, modules, ... }: {
  imports = [
    (modules.common.software + /cuda)
  ];

  environment.systemPackages = with pkgs; [ blender ];
}
