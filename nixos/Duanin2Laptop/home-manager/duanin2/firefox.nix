{ config, pkgs, ... }: let
  cfg = config.programs.firefox;
in {
  programs.firefox = {
    enable = true;
    package = let
      baseConfig = pkgs.fetchzip {
        url = "https://github.com/arkenfox/user.js/archive/refs/tags/115.1.zip";
        hash = "sha256-M523JiwiZR0mwjyjNaojSERFt77Dp75cg0Ifd6wTOdU=";
      };
      prefsFile = pkgs.writeText "arkenfox.user.js" (builtins.replaceStrings [ "user_pref" ] [ "defaultPref" ] (builtins.readFile "${baseConfig}/user.js"));
      binaryName = "firefox";
    in pkgs.firefox-esr.overrideAttrs (old: {
      postInstall = (old.postInstall or "") ++ ''
        # Install arkenfox's user.js
        install -Dvm644 ${prefsFile} $out/lib/${binaryName}/browser/defaults/preferences/arkenfox.user.js
      '';
    });

    profiles = {
      "default" = {
        id = 0;
        isDefault = true;

        search = {
          force = true;
          default = "SearXNG";

          engines = {
            "SearXNG" = {
              urls = [
                {
                  template = "https://searx.be/search";
                  params = [{
                    name = "q";
                    value = "{searchTerms}";
                  }];
                }
              ];
              iconUpdateURL = "https://searx.be/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # daily
              definedAliases = [
                "@sx"
                "@searxng"
              ];
            };
            "Amazon.com".metadata.hidden = true;
            "Bing".metadata.hidden = true;
            "DuckDuckGo".metadata.hidden = true;
            "Google".metadata.hidden = true;
            "Wikipedia (en)".metadata.hidden = true;
            "LibRedirect".metadata.hidden = true;
          };
          order = [ "SearXNG" ];
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          canvasblocker
          header-editor
          multi-account-containers
          behave
          keepassxc-browser
          redirector
          stylus
        ];
        bookmarks = [
          {
            name = "kernel.org";
            url = "https://www.kernel.org";
          }
          {
            name = "Nix";
            toolbar = true;
            
            bookmarks = [
              {
                name = "NixOS";
                tags = [ "nix" "nixos" ];
                url = "https://nixos.org/";
              }
              {
                name = "NixOS Wiki";
                tags = [ "nix" "nixos" "wiki" ];
                url = "https://nixos.wiki/";
              }
              {
                name = "GitHub";
                bookmarks = [
                  {
                    name = "NixOS/nixpkgs";
                    tags = [ "nix" "nixos" "git" ];
                    url = "https://github.com/NixOS/nixpkgs";
                  }
                  {
                    name = "nix-community/home-manager";
                    tags = [ "nix" "home-manager" "git" ];
                    url = "https://github.com/nix-community/home-manager";
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
