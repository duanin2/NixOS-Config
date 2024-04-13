{ ... }: {
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/tmp/hyprland"
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

  system.activationScripts."fix-home-perms" = {
    deps = [ "users" ];
    text = ''
      if ! [[ -e /home/duanin2 ]]; then
        mkdir -p /home/duanin2
      fi
      if [[ $(stat -c "%U" /home/duanin2/) != duanin2 ]]; then
        chown -R duanin2:users /home/duanin2
      fi
    '';
  };
}
