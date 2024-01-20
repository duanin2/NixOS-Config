{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;

    commandLineArgs = [
      "--ozone-platform-hint=auto"
    ];
    dictionaries = with pkgs; [
      hunspellDictsChromium.cs_CZ
      hunspellDictsChromium.en_GB
    ];
    extensions = [
      
    ];
  };
}