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

  isNumber = value: builtins.isInt value || builtins.isFloat value;

  convertor = {
		default,
		isAttrs ? default,
		isBool ? default,
		isFloat ? default,
		isFunction ? default,
		isInt ? default,
		isList ? default,
		isNull ? default,
		isPath ? default,
		isString ? default
	}: value: if builtins.isAttrs value then isAttrs
	else if builtins.isBool value then isBool
	else if builtins.isFloat value then isFloat
	else if builtins.isFunction value then isFunction
	else if builtins.isInt value then isInt
	else if builtins.isList value then isList
	else if builtins.isNull value then isNull
	else if builtins.isPath value then isPath
	else if builtins.isString value then isString
	else default;
}