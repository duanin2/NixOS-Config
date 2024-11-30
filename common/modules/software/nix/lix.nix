{ modules, inputs, ... }: {
  imports = [
    (if (modules.local ? software) then modules.local.software + /nix else modules.common.software + /nix)

    inputs.lix-module.nixosModules.default
  ];
}