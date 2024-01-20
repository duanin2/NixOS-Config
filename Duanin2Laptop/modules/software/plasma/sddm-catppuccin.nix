{ lib,
	stdenvNoCC,
	fetchFromGitHub,
	flavour ? [ "frappe" ],
  cursorTheme ? "Catppuccin-Frappe-Green-Cursors"
}: let
	validFlavours = [ "mocha" "macchiato" "frappe" "latte" ];
in
	lib.checkListOfEnum "Invalid flavour, valid flavours are ${toString validFlavours}" validFlavours flavour
stdenvNoCC.mkDerivation rec {
	pname = "catppuccin-sddm";
  version = "unstable-2023-12-05";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
    hash = "sha256-Jf4xfgJEzLM7WiVsERVkj5k80Fhh1edUl6zsSBbQi6Y=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes/"
    for FLAVOUR in ${toString flavour}; do
			cp -r src/catppuccin-$FLAVOUR/ "$out/share/sddm/themes/catppuccin-sddm-$FLAVOUR"
      echo -e "[General]\nCursorTheme=${cursorTheme}"
		done

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for SDDM.";
    homepage = "https://github.com/catppuccin/sddm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ { email = "tilldusan30@gmail.com"; github = "duanin2"; githubId = 1778670; name = "Dušan Till"; } ];
    platforms = lib.platforms.linux;
  };
}