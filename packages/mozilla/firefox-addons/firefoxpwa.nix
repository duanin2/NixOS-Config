{ lib, buildFirefoxXpiAddon, ... }: buildFirefoxXpiAddon rec {
  pname = "firefoxpwa";
  version = "2.12.1";

  addonId = "firefoxpwa@filips.si";

  url = "https://addons.mozilla.org/firefox/downloads/file/4293028/pwas_for_firefox-2.12.1.xpi";
  sha256 = "";

  meta = with lib; {
    description = "A tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox";

    homepage = "https://pwasforfirefox.filips.si/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ duanin2 ];
    platforms = platforms.all;
  };
}
