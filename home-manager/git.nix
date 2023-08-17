{ ... }: {
  enable = true;
  package = pkgs.gitFull;

  signing = {
    key = "39B537357EBA8818";
    signByDefault = true;
  };
  extraConfig = {
    user = {
      email = "duanin2@gmail.com";
      name = "duanin2";
    };
  };
}
