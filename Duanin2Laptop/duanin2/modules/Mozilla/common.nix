{
  writeText,
  ...
}: {
  src,
  package
}: package.override (old: {
  extraPrefsFiles = (old.extraPrefsFiles or []) ++ [
    (writeText
      "user.js"
      (builtins.replaceStrings
        [ "user_pref" ]
        [ "defaultPref" ]
        (builtins.readFile "${src}")))
  ];
})