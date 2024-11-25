{ persistDirectory, config, pkgs, ... }: {
  programs.tealdeer = {
    enable = true;

    settings = {
      display = {
        use_pager = true;
        compact = true;
      };
      updates = {
        auto_update = true;
        auto_update_interval_hours = 24;
      };
      directories = {
        custom_pages_dir = "${config.xdg.dataHome}/tealdeer/pages";
      };
    };
  };

  home.persistence.${persistDirectory}.directories = [
    ".cache/tealdeer"
  ];
}
