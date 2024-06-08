{ ... }: {
  services.logind = {
    suspendKeyLongPress = "ignore";
    powerKeyLongPress = "halt";
    powerKey = "poweroff";
    killUserProcesses = true;
  };
}
