{ config, lib, ... }: {
  programs.nushell = {
    enable = true;
  };

  programs.atuin.enableNushellIntegration = true;
  programs.carapace.enableNushellIntegration = true;
  programs.direnv.enableNushellIntegration = true;
  programs.keychain.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.yazi.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
}
