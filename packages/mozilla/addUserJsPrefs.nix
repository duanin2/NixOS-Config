{
  src,
  runCommand,
  lib,
  gnused
}: let
  removeComments = runCommand "firefoxPrefs" {} ''
echo "{" > $out;
${lib.getExe gnused} -E -e 's|//|#|' -e 's|/\*.*\*/||' -e 's|\s*user_pref\("|"|' -e 's|\);?|;|' -e 's|",\s*|"=|' -e '/^\s*$/d' ${src} >> $out;
echo "}" >> $out

${lib.getExe gnused} -E -i 's/"_user.js.parrot"=[^;]*;//' $out
  '';
in { res = (import removeComments); }
