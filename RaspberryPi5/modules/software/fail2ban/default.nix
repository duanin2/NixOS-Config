{ ... }: {
  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "192.168.1.0/24"
      "fe80::/64"
      "127.0.0.0/8"
      "::1/128"
    ];
    maxretry = 3;
    bantime-increment = {
      enable = true;

      rndtime = "15m";
      overalljails = false;
      maxtime = "${toString (24 * 7)}h";
    };
  };

  environment.persistence."/persist".directories = [
    "/var/lib/fail2ban"
  ];
}