# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    prismlauncher = prev.prismlauncher.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (prev.fetchpatch {
          url = "https://github.com/cs32767/PrismLauncher-Offline/commit/17de713e47379dbbc46236eb489f4e4a824a4fee.patch";
          hash = "sha256-M0LOiik7lx9y5K9rX416tLn5otrtmX71toI4Mw8Om10=";
        })
      ];
    });
    eww-systray = prev.eww.overrideAttrs (old: {
      version = "git";
      
      src = prev.fetchFromGitHub {
        owner = "ralismark";
        repo = "eww";
        rev = "tray-3";
        hash = "sha256-b/ipIavlmnEq4f1cQOrOCZRnIly3uXEgFbWiREKsh20=";
      };
      cargoDeps = prev.rustPlatform.importCargoLock {
        lockFile = (prev.fetchurl {
          url = "https://raw.githubusercontent.com/ralismark/eww/tray-3/Cargo.lock";
          hash = "sha256-Jy03au+JBpD1APFkVbcq/gmk1DcPVYUZ9kzDl6VuEBs=";
        });
      };
      patches = [ ];
      
      buildInputs = old.buildInputs ++ (with final; [
        glib
        librsvg
        libdbusmenu-gtk3
      ]);
      nativeBuildInputs = old.nativeBuildInputs ++ (with final; [ wrapGAppsHook ]);
    });
  };

  # Makes nixpkgs unstable accessible through pkgs.unstable
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
