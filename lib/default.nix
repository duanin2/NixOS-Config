final: prev: {
  mkIfElse = p: yes: no: final.mkMerge [
    (final.mkIf p yes)
    (final.mkIf (!p) no)
  ];

  contains = query: list: builtins.any (element: query == element) list;
}