{ config, lib, persistDirectory, ... }: {
  /*
  programs = (lib.appendConfig config.programs { enableNushellIntegration = true; }) // {
    nushell = {
      enable = true;
    };
  };
  */

  programs.nushell = {
    enable = true;

    configFile.text = ''
    $env.config = {
      show_banner: true

      rm: {
        always_trash: true
      }

      completions: {
        algorithm: "fuzzy"
      }
    }
    '';
  };

  programs.eza.enableNushellIntegration = true;
  programs.yazi.enableNushellIntegration = true;
  programs.atuin.enableNushellIntegration = true;
  programs.broot.enableNushellIntegration = true;
  programs.direnv.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.carapace.enableNushellIntegration = true;
  programs.keychain.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  # programs.gpg-agent.enableNushellIntegration = true;
  programs.oh-my-posh.enableNushellIntegration = true;

  home.persistence.${persistDirectory} = {
    files = [ ".config/nushell/history.txt" ];
  };
}
