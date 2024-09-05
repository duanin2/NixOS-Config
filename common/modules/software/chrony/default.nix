{ ... }: {
  services.chrony = {
    enable = true;

    servers = map (value: "${toString value}.pool.ntp.org") [ 0 1 2 3 ];
    serverOption = "offline";
    autotrimThreshold = 10;
  };
}
