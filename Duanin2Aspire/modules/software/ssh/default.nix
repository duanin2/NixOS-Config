{ ... }: {
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    forwardX11 = true;
    setXAuthLocation = true;
  };
}