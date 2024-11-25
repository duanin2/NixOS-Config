{ pkgs, persistDirectory, ... }: {
  home.packages = with pkgs; [
    (lutris.override {
      extraLibraries = (pkgs': pkgs'.wine.buildInputs);
      extraPkgs = (pkgs': pkgs'.wine64.nativeBuildInputs);
    })
  ];

  home.persistence.${persistDirectory} = {
    directories = [
      ".local/share/lutris"
      ".cache/lutris"
    ];
  };
}
