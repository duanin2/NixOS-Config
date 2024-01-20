{ pkgs, ... }: {
  environment.shells = with pkgs; [ nushellFull ];
}