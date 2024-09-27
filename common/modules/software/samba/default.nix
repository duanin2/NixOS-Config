{ ... }: {
  services.samba = {
    enable = true;

    nsswins = true;
    enableWinbindd = true;
    enableNmbd = true;
    openFirewall = true;
    settings = {
      global = {
        "client min protocol" = "NT1";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;

    openFirewall = true;
  };
}
