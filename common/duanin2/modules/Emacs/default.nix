{ pkgs, inputs, config, nur, ... }: {
  imports = [
    nur.repos.rycee.hmModules.emacs-init
  ];
  nixpkgs.overlays = [ inputs.emacs.overlays.default ];

  home.packages = with pkgs; [
    rust-analyzer
    typescript-language-server
  ];
  
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
    package = with pkgs; let
      emacsPackages = emacsPackagesFor emacs29-pgtk;
    in emacsPackages.emacsWithPackages (epkgs: with epkgs; [ treesit-grammars.with-all-grammars ]);

    init = {
      enable = true;
      
      recommendedGcSettings = true;

      # Borrowed from https://git.sr.ht/~rycee/configurations/tree/master/item/user/emacs.nix#L35-39
      earlyInit = let
        font = config.gtk.font;
      in ''
;; Set up fonts early.
(set-face-attribute 'default
			              nil
			              :family "${font.name}"
                    :height ${builtins.toString font.size}0)

;; https://git.sr.ht/~rycee/configurations/tree/master/item/user/emacs.nix#L32
(push '(tool-bar-lines . nil) default-frame-alist)
      '';

      postlude = ''
;; https://stackoverflow.com/questions/4191408/making-the-emacs-cursor-into-a-line
(setq-default cursor-type 'bar)

;; https://anonymousoverflow.privacyfucking.rocks/exchange/emacs/questions/278/how-do-i-display-line-numbers-in-emacs-not-in-the-mode-line#79455
(global-display-line-numbers-mode 1)

;; Stop the flood of warnings that sometimes happens upon file open
(custom-set-variables '(warning-suppress-types '((comp))))

(setenv "LSP_USE_PLISTS" "true")
(setq read-process-output-max (* 1024 1024)) ;; 1mb
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
(setq catppuccin-flavor '${config.catppuccin.flavor})
(load-theme 'catppuccin :no-confirm)
	        '';
	      };

        multiple-cursors = {
          enable = true;

          bind = {
            "<mouse-8>" = "mc/add-cursor-on-click";
          };
        };

        js-mode = {
          enable = true;

          mode = [
            ''"\\.mjs\\'"''
          ];
        };
        typescript-ts-mode = {
          enable = true;

          mode = [
            ''("\\.ts\\'" . typescript-ts-mode)''
            ''("\\.tsx\\'" . tsx-ts-mode)''
            ''("\\.mts\\'" . typescript-ts-mode)''
          ];
        };

        rust-mode = {
          enable = true;

          mode = [
            ''"\\.rs\\'"''
          ];
          config = ''
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

(setq rust-format-on-save t)
          '';
          init = ''
(setq rust-mode-treesitter-derive t)
          '';
        };

        lsp-mode = {
          enable = true;

          hook = [
            ''(rust-mode . lsp-deferred)''
            ''(nix-mode . lsp-deferred)''
            ''(typescript-ts-mode . lsp-deferred)''
            ''(tsx-ts-mode . lsp-deferred)''
            ''(js-mode . lsp-deferred)''
            ''(nushell-mode . lsp-deferred)''
          ];
          command = [
            "lsp-deferred"
          ];
          config = ''
(add-to-list 'load-path (expand-file-name "lib/lsp-mode" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lib/lsp-mode/clients" user-emacs-directory))

(setq lsp-nix-nil-server-path "${pkgs.nil}")
(setq lsp-log-io t)
          '';
        };

        magit = {
          enable = true;
        };

        forge = {
          enable = true;

          after = [
            "magit"
          ];
        };

        ligature = {
          enable = true;
          
          config = ''
(ligature-set-ligatures 't '("www")) ;; "www" ligature everywhere

(ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi")) ;; traditional ligatures in eww-mode

(ligature-set-ligatures 'prog-mode
                        '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                          ;; =:= =!=
                          ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                          ;; ;; ;;;
                          (";" (rx (+ ";")))
                          ;; && &&&
                          ("&" (rx (+ "&")))
                          ;; !! !!! !. !: !!. != !== !~
                          ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                          ;; ?? ??? ?:  ?=  ?.
                          ("?" (rx (or ":" "=" "\." (+ "?"))))
                          ;; %% %%%
                          ("%" (rx (+ "%")))
                          ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                          ;; |->>-||-<<-| |- |== ||=||
                          ;; |==>>==<<==<=>==//==/=!==:===>
                          ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                          "-" "=" ))))
                          ;; \\ \\\ \/
                          ("\\" (rx (or "/" (+ "\\"))))
                          ;; ++ +++ ++++ +>
                          ("+" (rx (or ">" (+ "+"))))
                          ;; :: ::: :::: :> :< := :// ::=
                          (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                          ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                          ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                          "="))))
                          ;; .. ... .... .= .- .? ..= ..<
                          ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                          ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                          ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                          ;; *> */ *)  ** *** ****
                          ("*" (rx (or ">" "/" ")" (+ "*"))))
                          ;; www wwww
                          ("w" (rx (+ "w")))
                          ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                          ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                          ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                          ;; << <<< <<<<
                          ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                          "-"  "/" "|" "="))))
                          ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                          ;; >> >>> >>>>
                          (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                          ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                          ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                       (+ "#"))))
                          ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                          ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                          ;; __ ___ ____ _|_ __|____|_
                          ("_" (rx (+ (or "_" "|"))))
                          ;; Fira code: 0xFF 0x12
                          ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                          ;; Fira code:
                          "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                          ;; The few not covered by the regexps.
                          "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))

(global-ligature-mode t) ;; Enable ligatures
          '';
        };

        treemacs = {
          enable = true;

          defer = true;
          init = ''
(with-eval-after-load 'winum
                      (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
          '';
          config = ''
(treemacs-follow-mode t)
(treemacs-filewatch-mode t)
(treemacs-fringe-indicator-mode 'always)
(when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

(pcase (cons (not (null (executable-find "git")))
             (not (null treemacs-python-executable)))
       (`(t . t)
            (treemacs-git-mode 'deferred))
       (`(t . _)
            (treemacs-git-mode 'simple)))

(treemacs-start-on-boot)
          '';
          bind = {
            "M-0" = "treemacs-select-window";
            "C-x t 1" = "treemacs-delete-other-windows";
            "C-x t t" = "treemacs";
            "C-x t d" = "treemacs-select-directory";
            "C-x t B" = "treemacs-bookmark";
            "C-x t C-t" = "treemacs-find-file";
            "C-x t M-t" = "treemacs-find-tag";
          };
        };
        treemacs-icons-dired = {
          enable = true;

          hook = [
            "(dired-mode . treemacs-icons-dired-enable-once)"
          ];
        };
        treemacs-magit = {
          enable = true;

          after = [
            "treemacs"
            "magit"
          ];
        };
        lsp-treemacs = {
          enable = true;

          after = [
            "lsp-mode"
            "treemacs"
          ];
        };

        yasnippet = {
          enable = true;

          earlyInit = ''
(yas-global-mode 1)
          '';
        };
        yasnippet-snippets = {
          enable = true;
        };
      };
    };
  };
}
