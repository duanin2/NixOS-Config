# This file defines overlays
{ inputs, lib, ... }:
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

  # Replace packages with newer versions
  updates = final: prev: {
    wayland-protocols = final.unstable.wayland-protocols.override { inherit (final) lib stdenv fetchurl pkg-config meson ninja wayland-scanner python3 wayland; };
    wayland = final.unstable.wayland.override { inherit (final) lib stdenv fetchurl substituteAll meson pkg-config ninja wayland-scanner expat libxml2 libffi epoll-shim graphviz-nox doxygen libxslt xmlto python3 docbook_xsl docbook_xml_dtd_45 docbook_xml_dtd_42; };

    mesa = final.mesa_git.override {
      inherit (final) stdenv lib fetchurl fetchpatch meson pkg-config ninja intltool bison flex file python3Packages wayland-scanner expat libdrm xorg wayland wayland-protocols openssl llvmPackages_15 libffi libomxil-bellagio libva-minimal libelf libvdpau libglvnd libunwind vulkan-loader glslang OpenGL Xplugin valgrind-light libclc jdupes rustc rust-bindgen spirv-llvm-translator zstd directx-headers udev;

      galliumDrivers = [
        "swrast"
        "zink"
        "iris"
      ];
      vulkanDrivers = [
        "swrast"
        "intel"
      ];
    };

    meson = (final.meson_next.override { inherit (final) lib stdenv fetchpatch installShellFiles ninja pkg-config python3 zlib coreutils substituteAll Foundation OpenGL AppKit Cocoa libxcrypt; }).overrideAttrs (old: { });
  };

  # Makes nixpkgs unstable accessible through pkgs.unstable
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
