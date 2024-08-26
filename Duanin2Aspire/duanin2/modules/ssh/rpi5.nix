{ homeDirectory, ... }: {
  programs.ssh.matchBlocks."RPi5" = {
    host = "RPi5";
    hostname = "duanin2.top";
    port = 22;
    user = "duanin2";
    identityFile = "${homeDirectory}/.ssh/rpi5";
    
    forwardX11Trusted = true;
    forwardAgent = true;
  };
}
