{ homeDirectory, ... }: {
  programs.ssh.matchBlocks."github" = {
    host = "github";
    hostname = "github.com";
    port = 22;
    user = "git";
    forwardX11 = false;
    identityFile = "${homeDirectory}/.ssh/github";
  };
}