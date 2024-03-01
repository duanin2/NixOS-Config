final: prev: {
  mkIfElse = p: yes: no: final.mkMerge [
    (final.mkIf p yes)
    (final.mkIf (!p) no)
  ];

  maintainers = (prev.maintainers or []) ++ [
    {
      email = "tilldusan30@gmail.com";
      github = "duanin2";
      githubId = 1778670;
      name = "Dušan Till";
    }
  ];

  contains = query: list: builtins.any (element: query == element) list;
}