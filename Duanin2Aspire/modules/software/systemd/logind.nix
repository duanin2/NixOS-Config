{ ... }: {
  services.logind = {
    suspendKeyLongPress = "ignore";
    powerKeyLongPress = "halt";
    powerKey = "shutdown";
    killUserProcesses = true;
  };
}
