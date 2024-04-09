{ config, lib, persistDirectory, ... }: {
  programs = (lib.setAttrs { enableNushellIntegration = true; } config.programs) // {
    nushell = {
      enable = true;
    };
  };

  home.persistence.${persistDirectory} = {
    files = [ ".config/nushell/history.txt" ];
  };
}
