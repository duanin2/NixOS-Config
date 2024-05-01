{ ... }: {
  programs.adb = {
    enable = true;
  };

  users.users."duanin2".extraGroups = [ "adbusers" ];
}