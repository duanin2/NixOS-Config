{ ... }: {
  services.chrony = {
    enable = true;

    autotrimThreshold = 10;
  };
}
