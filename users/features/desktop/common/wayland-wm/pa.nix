{ pkgs, ... }: {
  home.packages = with pkgs; [
    pavucontrol
    pulseaudio
  ];
}