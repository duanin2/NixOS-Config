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
    eww-systray = prev.callPackage prev.eww {
      rustPlatform = prev.rustPlatform // {
        buildRustPackage = args: prev.rustPlatform.buildRustPackage (args // {
          src = prev.fetchFromGithub {
            owner = "ralismark";
            repo = "eww";
            rev = "tray-3";
            hash = "";
          };
          cargoHash = "";

          nativeBuildInputs = (args.nativeBuildInputs or []) ++ (with final; [
            wrapGAppsHook
          ]);
          buildInputs = (args.buildInputs or []) ++ (with final; [
            glib
            librsvg
            libdbusmenu-gtk3
          ]);
        });
      };
    };
    mesa-next = (prev.mesa.override {
      meson = inputs.nixpkgs-staging.legacyPackages.x86_64-linux.meson.override {
        lib = final.lib;
        stdenv = final.stdenv;
        fetchFromGitHub = final.fetchFromGitHub;
        fetchpatch = final.fetchpatch;
        installShellFiles = final.installShellFiles;
        ninja = final.ninja;
        pkg-config = final.pkg-config;
        python3 = final.python3;
        zlib = final.zlib;
        coreutils = final.coreutils;
        substituteAll = prev.substituteAll;
        Foundation = final.Foundtation;
        OpenGL = final.OpenGL;
        AppKit = final.AppKit;
        Cocoa = final.Cocoa;
        libxcrypt = final.libxcrypt;
      };
      
      galliumDrivers = [
        "iris"
        "zink"
	"swrast"
      ];
      vulkanDrivers = [
        "intel"
        "swrast"
      ];
    }).overrideAttrs (old: {
      version = "23.1.5";
      hash = "";

      mesonFlags = (old.mesonFlags or []) ++ [
        "-Dgallium-vdpau=false"
        "-Dgallium-va=false"
        "-Dgallium-xa=false"
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
