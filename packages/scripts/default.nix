{ callPackage }: {
  battery = callPackage ./nushell/battery.nix { };
  uevent = callPackage ./nushell/uevent.nix { };
  nmcli = callPackage ./nushell/nmcli.nix { };
  hyprlandSock2 = callPackage ./nushell/hyprlandSock2.nix { };
}
