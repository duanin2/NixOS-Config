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

      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";

      rndtime = "1h";
      overalljails = true;
      maxtime = "${toString (24 * 7)}h";
    };
  };

  environment.persistence."/persist".directories = [
    "/var/lib/fail2ban"
  ];
}