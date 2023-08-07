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
        base16-theme = {
	        enable = true;
	        config = ''
;; base16-nix-colors-${config.colorScheme.slug}-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/tinted-theming/home)
;; Nix Colors: (https://github.com/Misterio77/nix-colors)
;; Home Manager: (https://github.com/nix-community/home-manager)

;;; Authors:
;; Scheme: ${config.colorScheme.author}
;; Template: Kaleb Elwert <belak@coded.io>
;; Port to Nix Colors: Dušan Till <duanin2@gmail.com>

(defvar base16-nix-colors-${config.colorScheme.slug}-theme-colors
        '(:base00 "#${config.colorScheme.colors.base00}"
	  :base01 "#${config.colorScheme.colors.base01}"
	  :base02 "#${config.colorScheme.colors.base02}"
	  :base03 "#${config.colorScheme.colors.base03}"
	  :base04 "#${config.colorScheme.colors.base04}"
	  :base05 "#${config.colorScheme.colors.base05}"
	  :base06 "#${config.colorScheme.colors.base06}"
	  :base07 "#${config.colorScheme.colors.base07}"
	  :base08 "#${config.colorScheme.colors.base08}"
	  :base09 "#${config.colorScheme.colors.base09}"
	  :base0A "#${config.colorScheme.colors.base0A}"
	  :base0B "#${config.colorScheme.colors.base0B}"
	  :base0C "#${config.colorScheme.colors.base0C}"
	  :base0D "#${config.colorScheme.colors.base0D}"
	  :base0E "#${config.colorScheme.colors.base0E}"
	  :base0F "#${config.colorScheme.colors.base0F}")
	"All colors for Base16 ${config.colorScheme.name} are defined here.")

;; Define the theme
(deftheme base16-nix-colors-${config.colorScheme.slug})

;; Add all the faces to the theme
(base16-theme-define 'base16-nix-colors-${config.colorScheme.slug})

;; Mark the theme as provided
(provide-theme 'base16-nix-colors-${config.colorScheme.slug})

(provide 'base16-nix-colors-${config.colorScheme.slug}-theme)

;; Load Base16 Nix Colors
(load-theme 'base-nix-colors-${config.colorScheme.slug} t)
	        '';
	      };

        nix-mode = {
	        enable = true;
	        mode = [ ''"\\.nix\\'"'' ];
	        hook = [ "(nix-mode . subword-mode)" ];
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
