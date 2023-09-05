{ config, ... }: {
  enable = true;

  # Configuration
  enableAutosuggestions = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;
  autocd = true;
  defaultKeymap = "emacs";
  initExtra = ''
function launchbg() {
  sh -c "\
  exec $1 &" \
  &> /dev/null
}
'';

  # ZSH history settings
  history = {
    expireDuplicatesFirst = true;
    extended = true;
    ignoreSpace = true;
    path = "${config.home.homeDirectory}/.zsh_history";
    save = 100000;
  };
}
