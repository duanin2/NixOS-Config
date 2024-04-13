{ config, lib, persistDirectory, ... }: {
  /*
  programs = lib.setAttrs { enableNushellIntegration = true; } config.programs // {
    nushell = {
      enable = true;
    };
  };
  */

  programs.nushell = {
    enable = true;
  };

  programs.yazi.enableNushellIntegration = true;
  programs.atuin.enableNushellIntegration = true;
  programs.direnv.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.carapace.enableNushellIntegration = true;
  programs.keychain.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;

  home.persistence.${persistDirectory} = {
    files = [ ".config/nushell/history.txt" ];
  };
}
