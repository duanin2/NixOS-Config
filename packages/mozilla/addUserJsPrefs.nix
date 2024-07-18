{
  src,
  runCommand,
  lib,
  gnused
}: package.override (old: let
  removeComments = runCommand "firefoxPrefs" {} ''
echo "{" > $out;
${lib.getExe gnused} -E -e 's|^//.*$||' -e 's|^\s*user_pref\("|"|' -e 's|\);\s*$|;|' -e 's|",\s*|"=|' -e '/^\s*$/d' ${src} >> $out;
echo "}" >> $out
  '';
in import removeComments;
