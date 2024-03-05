{ ... }: {
  programs.gnupg = {
    agent = {
      enable = true;

      enableSSHSupport = true;
      pinentryFlavour = "qt";
    };
  };
}