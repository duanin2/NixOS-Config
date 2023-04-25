{ stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, symlinkJoin
, buildFHSUserEnv
, pkg-config
, installShellFiles
, lib
}:
let
  version = "2.4.1";
  dir = "native";
  source = fetchFromGitHub {
    owner = "filips123";
    repo = "PWAsForFirefox";
    rev = "v${version}";
    sha256 = "sha256-AkCTfbWsAF6N1hmowK33XzI2bnBlbzML9IiGjujc8N8=";
    sparseCheckout = [ dir ];
  };
  pname = "firefoxpwa";

  unwrapped = rustPlatform.buildRustPackage {
    inherit version;
    pname = "${pname}-unwrapped";

    src = "${source}/${dir}";
    cargoSha256 = "sha256-BHEFBrDrSZv9Bwl4q+MQA1BAoaJOxsNc/IK6ygrjwVY=";

    doCheck = false;

    nativeBuildInputs = [ pkg-config installShellFiles ];
    buildInputs = [ openssl.dev openssl ];

    preConfigure = ''
      sed -i 's;version = "0.0.0";version = "${version}";' Cargo.toml
      sed -zi 's;name = "firefoxpwa"\nversion = "0.0.0";name = "firefoxpwa"\nversion = "${version}";' Cargo.lock
      sed -i $'s;DISTRIBUTION_VERSION = \'0.0.0\';DISTRIBUTION_VERSION = \'${version}\';' userchrome/profile/chrome/pwa/chrome.jsm
    '';

    FFPWA_EXECUTABLES = ""; # .desktop entries generated without any store path references
    FFPWA_SYSDATA = "${placeholder "out"}/share/firefoxpwa";
    target = "target/${stdenv.targetPlatform.config}/release";

    postInstall = ''
      mv $out/bin/firefoxpwa $out/bin/.firefoxpwa-wrapped
      # Manifest
      sed -i "s!/usr/libexec!$out/bin!" manifests/linux.json
      install -Dm644 manifests/linux.json $out/lib/mozilla/native-messaging-hosts/firefoxpwa.json
      # Completions
      installShellCompletion --bash $target/completions/firefoxpwa.bash
      installShellCompletion --fish $target/completions/firefoxpwa.fish
      installShellCompletion --zsh $target/completions/_firefoxpwa
      # UserChrome
      mkdir -p $out/share/firefoxpwa/userchrome/
      cp -r userchrome/* "$out/share/firefoxpwa/userchrome"
    '';
  };
  # firefoxpwa wants to run binaries downloaded into users' home dir
  fhs = buildFHSUserEnv {
    name = pname;
    runScript = "${unwrapped}/bin/.firefoxpwa-wrapped";
    targetPkgs = pkgs: with pkgs;[
      dbus-glib
      gtk3
      alsaLib
      xorg.libXtst
      xorg.libX11
    ];
  };
in
(symlinkJoin {
  name = "${pname}-${version}";
  paths = [ fhs unwrapped ];
}) // {
  inherit unwrapped fhs pname version;
  meta = with lib;{
    description = "Tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox";
    homepage = "https://github.com/filips123/PWAsForFirefox";
    maintainers = with maintainers;[ pasqui23 ];
    license = licenses.mpl20;
    platform = [ platforms.unix ];
  };
}