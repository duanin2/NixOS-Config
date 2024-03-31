{ lib, buildFirefoxXpiAddon, ... }: buildFirefoxXpiAddon rec {
  pname = "librejs";
  version = "7.21.1";

  addonId = "jid1-KtlZuoiikVfFew@jetpack";

  url = "https://ftp.gnu.org/gnu/librejs/librejs-${version}.xpi";
  sha256 = "sha256-YMWxZjqyUH3BIRLkQHa7mcj+7Qd3tNQO50ua7xsMclY=";

  meta = with lib; {
    description = "LibreJS is a free add-on for GNU IceCat and other Mozilla-based browsers. It blocks nonfree nontrivial JavaScript while allowing JavaScript that is free and/or trivial.";
    longDescription = "GNU LibreJS aims to address the JavaScript problem described in Richard Stallman's article The JavaScript Trap. LibreJS is a free add-on for GNU IceCat and other Mozilla-based browsers. It blocks nonfree nontrivial JavaScript while allowing JavaScript that is free and/or trivial.";

    homepage = "https://www.gnu.org/software/librejs/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ duanin2 ];
    platforms = platforms.all;
  };
}