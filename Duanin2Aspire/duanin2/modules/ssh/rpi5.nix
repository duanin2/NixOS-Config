{ pkgs, ... }: {
  programs.ssh.matchBlocks."RPi5" = {
    host = "RPi5";
    hostname = "rpi.duanin2.top";
    port = 22;
    user = "duanin2";
    proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
  };
}