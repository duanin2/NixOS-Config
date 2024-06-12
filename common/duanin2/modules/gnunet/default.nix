{ ... }: {
  xdg.configFile."gnunet.conf" = {
    enable = true;

    text = ''
[arm]
START_SYSTEM_SERVICES = NO
START_USER_SERVICES = YES
    '';
  };
}
