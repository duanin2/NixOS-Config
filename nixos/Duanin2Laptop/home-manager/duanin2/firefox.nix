{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox_nightly;

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
        ];
        extraConfig = (builtins.readFile "${pkgs.fetchFromGitHub { owner = "arkenfox"; repo = "user.js"; rev = "master"; hash = "sha256-IfQNepLwoG9qygeDGj5egnLQUR47LOjBV1PFJtt0Z64="; }}/user.js");
        bookmarks = [
          {
            name = "Nix";
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
