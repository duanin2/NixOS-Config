{ pkgs, inputs, config, nur, ... }: {
  imports = [
    nur.repos.rycee.hmModules.emacs-init
  ];
  nixpkgs.overlays = [ inputs.emacs.overlays.default ];
  
  services.emacs = {
    enable = true;
    package = config.programs.emacs.finalPackage;
    
    client = {
      enable = true;
      
      arguments = [
        "-r"
        "-n"
      ];
    };
    defaultEditor = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;

    init = {
      enable = true;
      
      recommendedGcSettings = true;

      # Borrowed from https://git.sr.ht/~rycee/configurations/tree/master/item/user/emacs.nix#L35-39
      earlyInit = ''
        ;; Set up fonts early.
	      (set-face-attribute 'default
			                      nil
			                      :height 100
			                      :family "FiraCode Nerd Font Mono")
      '';

      postlude = ''
        ;; https://stackoverflow.com/questions/4191408/making-the-emacs-cursor-into-a-line
        (setq-default cursor-type 'bar)

        ;; https://emacs.stackexchange.com/questions/278/how-do-i-display-line-numbers-in-emacs-not-in-the-mode-line
        (add-hook 'prog-mode-hook 'display-line-numbers-mode)
      '';

      usePackage = {
        nix-mode = {
	        enable = true;
	  
	        mode = [
	          ''"\\.nix\\'"''
	          ''"\\.nix.in\\'"''
	        ];
	      };
	      nix-drv-mode = {
	        enable = true;
	        package = "nix-mode";

	        mode = [ ''"\\.drv\\'"'' ];
	      };
	      nix-repl = {
	        enable = true;
	        package = "nix-mode";

	        command = [ "nix-repl" ];
	      };
	      nix-shell = {
	        enable = true;
	        package = "nix-mode";

	        command = [
	          "nix-shell-unpack"
	          "nix-shell-configure"
	          "nix-shell-build"
	        ];
	      };
        
	      nushell-mode = {
	        enable = true;
	      };

        php-mode = {
          enable = true;

          mode = [ ''"\\.php\\'"'' ];
        };
	
	      catppuccin-theme = {
	        enable = true;
         
	        defer = true;
	        # I borrowed this from https://git.sr.ht/~rycee/configurations/tree/master/item/user/emacs.nix#L291-296
	        earlyInit = ''
	          ;; Set color theme in early init to avoid flashing during start.
            (require 'catppuccin-theme)
            (setq catppuccin-flavor '${config.catppuccin.flavour})
            (load-theme 'catppuccin :no-confirm)
	        '';
	      };

        multiple-cursors = {
          enable = true;

          command = with builtins; [
            "mc/mark-next-like-this"
            "mc/mark-next-like-this-word"
            "mc/mark-next-like-this-symbol"
            "mc/mark-next-word-like-this"
            "mc/mark-next-symbol-like-this"
            "mc/mark-previous-like-this"
            "mc/mark-previous-like-this-word"
            "mc/mark-previous-like-this-symbol"
            "mc/mark-previous-word-like-this"
            "mc/mark-previous-symbol-like-this"
            "mc/mark-more-like-this-extended"
            "mc/add-cursor-on-click"
            "mc/mark-pop"
            "mc/unmark-next-like-this"
            "mc/unmark-previous-like-this"
            "mc/skip-to-next-like-this"
            "mc/skip-to-previous-like-this"
            "mc/edit-lines"
            "mc/edit-beginnings-of-lines"
            "mc/edit-ends-of-lines"
            "mc/mark-all-like-this"
            "mc/mark-all-words-like-this"
            "mc/mark-all-symbols-like-this"
            "mc/mark-all-in-region"
            "mc/mark-all-like-this-in-defun"
            "mc/mark-all-words-like-this-in-defun"
            "mc/mark-all-symbols-like-this-in-defun"
            "mc/mark-all-dwim"
            "set-rectangular-region-anchor"
            "mc/mark-sgml-tag-pair"
            "mc/insert-numbers"
            "mc/insert-letters"
            "mc/sort-regions"
            "mc/reverse-regions"
            "mc/vertical-align"
            "mc/vertical-align-with-space"
          ];
          bindKeyMap = {
            "<mouse-8>" = "mc/add-cursor-on-click";
          };
        };
      };
    };
  };
}
