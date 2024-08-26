{ homeDirectory, ... }: {
  programs.ssh.matchBlocks."github" = {
    host = "github";
    hostname = "github.com";
    port = 22;
    user = "git";
    identityFile = "${homeDirectory}/.ssh/github";
    
    forwardX11 = false;
    forwardX11Trusted = false;
  };
}
