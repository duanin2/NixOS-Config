{
  inputs    ,
  pkgs      ,
  config    ,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;

    init = {
      enable = true;

      recommendedGcSettings = true;
      prelude = ''
;; Disable startup message.
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message (user-login-name))

;; Accept 'y' and 'n' rather than 'yes' and 'no'.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Use a 2 character wide TAB.
(setq-default indent-tabs-mode t
              tab-width 2)

;; Prefer UTF-8.
(prefer-coding-system 'utf-8)

;; Improved handling of clipboard.
(setq select-enable-clipboard t
      select-enable-primary t
      save-interprogram-paste-before-kill t)

;; Pasting with middle click should insert at point, not where the
;; click happened.
(setq mouse-yank-at-point t)

;; Show line numbers.
(when (version<= "26.0.50" emacs-version)
      (global-display-line-numbers-mode))
      '';
      usePackage = {
        catppuccin-theme = {
          enable = true;
          config = ''
(load-theme 'catppuccin :no-confirm)

(setq catppuccin-flavour 'frappe)
(catppuccin-reload)
          '';
        };

        nix-mode = {
	        enable = true;
	        mode = [ ''"\\.nix\\'"'' ];
	        hook = [ "(nix-mode . subword-mode)" ];
	      };

        magit = {
          enable = true;
        };
      };
    };
  };
  services.emacs = {
    enable = true;

    client = {
      enable = true;
      arguments = [
        "--reuse-frame"
        "--no-wait"
      ];
    };
    defaultEditor = true;
    socketActivation.enable = true;
  };
}
