{ callPackage }: {
  battery = pkgs.callPackage ./nushell/battery.nix;
  uevent = pkgs.callPackage ./nushell/uevent.nix;
  nmcli = pkgs.callPackage ./nushell/nmcli.nix;
}
