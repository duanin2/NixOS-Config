{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
    };
  };

  users.users."duanin2".extraGroups = [ "libvirtd" ];

  environment.persistence."/persist".directories = [ "/var/lib/libvirt" ];
}
