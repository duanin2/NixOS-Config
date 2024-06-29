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
        (custom-set-variables
          '(warning-suppress-types '((comp))))
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
          config = ''
          (global-set-key (kbd "<mouse-8>") 'mc/add-cursor-on-click)
          '';
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
      };
    };
  };
}
