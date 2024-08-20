{ inputs, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/tmp/hyprland"
      {
        directory = "/tmp";
        user = "root";
        group = "root";
        mode = "1777";
      }
    ];
    files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
    users.duanin2 = {
      directories = [
        ".local/state/nix/profiles"
      ];
    };
  };

  systemd.services."home-manager-duanin2-fix-home" = {
    wantedBy = [ "home-manager-duanin2.service" ];
    script = ''
      mkdir -p /home/duanin2
      chown -R duanin2:users /home/duanin2
    '';
  };
}
