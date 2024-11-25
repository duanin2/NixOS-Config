{ pkgs, modules, ... }: {
  imports = [
    (modules.local.software + /cuda)
  ];

  environment.systemPackages = with pkgs; [ blender ];
}
