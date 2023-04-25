{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    history = {
      extended = true;
      ignoreDups = true;
      ignorePatterns = [ "rm *" "ls *" "pkill *" "pgrep *" ];
      ignoreSpace = true;
      share = true;
    };
    initExtra = ''
eval "$(direnv hook zsh)"
    '';
  };
}