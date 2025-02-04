{ inputs, config, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/secrets"
      {
        directory = "/tmp";
        user = "root";
        group = "root";
        mode = "1777";
      }
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  systemd.services = {
    "home-manager-duanin2-fix-home" = {
      wantedBy = [ "home-manager-duanin2.service" ];
      script = ''
mkdir -p /home/duanin2
chown -R duanin2:users /home/duanin2
    '';
    };
    "clear-tmp" = {
      wantedBy = [ "tmp.mount" ];

      after = [ "persist.mount" ];
      before = [ "tmp.mount" ];

      script = ''
rm -rf /persist/tmp/*
      '';
    };
  };
}
