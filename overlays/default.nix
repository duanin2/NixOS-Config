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
          url = "https://github.com/PrismLauncher/PrismLauncher/commit/17de713e47379dbbc46236eb489f4e4a824a4fee.patch";
          hash = "sha256-M0LOiik7lx9y5K9rX416tLn5otrtmX71toI4Mw8Om10=";
        })
      ];
    });
    gamescope = (prev.gamescope.override {
      wlroots = final.wlroots_0_16;
    }).overrideAttrs (old: {
      version = "git";

      src = prev.fetchFromGitHub {
        owner = "ValveSoftware";
	repo = "gamescope";
	rev = "master";
	hash = "sha256-UpY9O6X2YLYCpXkAXzjQwk+yiRj2cMlVbi+OtIHEdI8=";
      };
    });
  };
}
