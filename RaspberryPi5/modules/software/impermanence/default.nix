{ inputs, config, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/acme"
      "/var/lib/secrets"
      "/var/lib/aria2"
      "/var/lib/postgresql"
      "/var/lib/invidious"
      "/var/lib/private/invidious"
      "/home/openvscode-server"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  systemd.services."home-manager-duanin2-fix-home" = {
    wantedBy = [ "home-manager-duanin2.service" ];
    script = ''
      mkdir -p /home/duanin2
      chown -R duanin2:users /home/duanin2
    '';
  };
}
