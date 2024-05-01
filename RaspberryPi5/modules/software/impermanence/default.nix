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
}