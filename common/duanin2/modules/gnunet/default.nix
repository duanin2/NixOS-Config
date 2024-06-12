{ ... }: {
  xdg.configFile."gnunet.conf" = {
    enable = true;

    text = ''
[PATHS]
GNUNET_HOME = /var/lib/gnunet
GNUNET_RUNTIME_DIR = /run/gnunet
GNUNET_USER_RUNTIME_DIR = /run/gnunet
GNUNET_DATA_HOME = /var/lib/gnunet/data

[ats]
WAN_QUOTA_IN = 50000 b
WAN_QUOTA_OUT = 50000 b

[datastore]
QUOTA = 1024 MB

[transport-udp]
PORT = 2086
ADVERTISED_PORT = 2086

[transport-tcp]
PORT = 2086
ADVERTISED_PORT = 2086

[arm]
START_SYSTEM_SERVICES = NO
START_USER_SERVICES = YES
    '';
  };
}
