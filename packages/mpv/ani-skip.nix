{
  lib,
  fetchFromGitHub,
  gitUpdater,
  stdenvNoCC,
  fzf,
  bash
}: stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ani-skip";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "synacktraa";
    repo = "ani-skip";
    rev = finalAttrs.version;
    hash = "sha256-VEEG3d6rwTAS7/+gBKHFKIg9zFfBu5eBOu6Z23621gM=";
  };
  passthru.updateScript = gitUpdater { };

  buildInputs = [
    fzf
    bash
  ];

  installPhase = ''
runHook preInstall

install -Dm 755 ani-skip $out/bin/ani-skip
install -D skip.lua $out/share/mpv/scripts/skip.lua

runHook postInstall
  '';

  passthru.scriptName = "skip.lua";

  meta = {
    description = "A script that offers an automated solution to bypass anime opening and ending sequences, enhancing your viewing experience by eliminating the need for manual intro and outro skipping.";
    homepage = "https://github.com/synacktraa/ani-skip";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ duanin2 ];
  };
})
