{ ... }: {
  services.samba = {
    enable = true;

    nsswins = true;
    enableWinbindd = true;
    extraConfig = ''
    client min protocol = NT1
    '';
  };
}