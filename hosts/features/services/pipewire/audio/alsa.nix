{ ... }: {
  imports = [
    ./..
  ];
  services.pipewire.alsa = {
    enable = true;
    support32Bit = true;
  };
}