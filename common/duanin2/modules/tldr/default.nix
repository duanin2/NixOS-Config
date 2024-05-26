{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    tealdeer
  ];

  home.persistence.${persistDirectory}.directories = [
    ".cache/tealdeer/tldr-pages"
  ];

  xdg.configFile."tealdeer/config.toml" = {
    enable = true;

    text = (pkgs.formats.toml {}).generate "tealdeer-conf" {
      display = {
        use_pager = true;
        compact = true;
      };
      updates = {
        auto_update = true;
        auto_update_interval_hours = 1;
      };
      directories = {
        custom_pages_dir = "${config.xdg.dataHome}/tealdeer/pages";
      };
    };
  };
}
