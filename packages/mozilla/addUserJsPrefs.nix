{
  writeText,
  src,
  package,
  ...
}: package.override (old: let
  prefsFile = (builtins.replaceStrings
                [ "user_pref" ]
                [ "defaultPref" ]
                (builtins.readFile "${src}"));
in {
  extraPrefsFiles = (old.extraPrefsFiles or []) ++ [
    (writeText
      "user.js"
      prefsFile)
  ];
})
