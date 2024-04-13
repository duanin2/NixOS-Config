{ pkgs, nur, ... }: {
  home.packages = with pkgs; [
    keepassxc
  ];

  programs.firefox.profiles."default".extensions = with nur.repos.rycee.firefox-addons; [
    keepassxc-browser
  ];
}