{ ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      firefox = prev.firefox.override (old: {
        nativeMessagingHosts = (old.nativeMessagingHosts or []) ++ (with final; [ keepassxc ]);
      });
    })
  ];
}