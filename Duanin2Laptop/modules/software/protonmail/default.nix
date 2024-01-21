{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    protonmail-bridge
  ];
}