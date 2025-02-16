{ pkgs, nur, persistDirectory, ... }: {
  home.packages = with pkgs; [
    keepassxc
  ];

  programs.firefox.profiles."default".extensions = with nur.repos.rycee.firefox-addons; [
    keepassxc-browser
  ];

  home.persistence.${persistDirectory} = {
    directories = [
      "KeePass"
    ];
    files = [
      ".config/keepassxc/keepassxc.ini"
      ".config/KeePassXCrc"
    ];
  };
}
