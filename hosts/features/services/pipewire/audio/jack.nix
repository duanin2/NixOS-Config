{ ... }: {
  imports = [
    ./..
  ];
  services.pipewire.jack.enable = true;
}