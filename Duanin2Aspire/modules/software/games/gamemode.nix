{ pkgs, ... }: {
  programs.gamemode = {
    enable = true;

    enableRenice = true;
    settings = {
      general = {
        reaper_freq = 10;
        desiredgov = "performance";
        renice = 15;
        ioprio = 0;
        inhibit_screensaver = true;
      };
    };
  };
}
