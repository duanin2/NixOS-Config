{ ... }: {
  services.samba = {
    enable = true;

    nsswins = true;
    winbindd.enable = true;
    nmbd.enable = true;
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
