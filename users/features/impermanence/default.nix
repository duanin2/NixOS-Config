{inputs, pkgs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  systemd.user.startServices = pkgs.lib.mkForce true;
}