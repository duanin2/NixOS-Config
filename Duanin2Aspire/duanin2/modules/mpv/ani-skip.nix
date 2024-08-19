{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  buildLua,
  mpv-unwrapped
}: buildLua {
  pname = "ani-skip";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "synacktraa";
    repo = "ani-skip";
    rev = "1.0.1";
    hash = "";
  };
  passthru.updateScript = gitUpdater { };

  passthru.extraWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ mpv-unwrapped ])
  ];

  meta = {
    description = "A script that offers an automated solution to bypass anime opening and ending sequences, enhancing your viewing experience by eliminating the need for manual intro and outro skipping.";
    homepage = "https://github.com/synacktraa/ani-skip";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ duanin2 ];
  };
}
