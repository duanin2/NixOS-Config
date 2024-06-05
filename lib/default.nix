final: prev: with final; with builtins; {
  mkIfElse = p: yes: no: mkMerge [
    (mkIf p yes)
    (mkIf (!p) no)
  ];

  maintainers = (prev.maintainers or {}) // {
    duanin2 = {
      email = "tilldusan30@gmail.com";
      github = "duanin2";
      githubId = 1778670;
      name = "Dušan Till";
    };
  };

  platforms = (prev.platforms or {}) // {
    bsd = with prev; freebsd ++ netbsd ++ openbsd;
  };

  contains = query: list: any (element: query == element) list;

  isNumber = value: isInt value || isFloat value;

  convertor = {
		default,
    ...
	}@types: value: types.${typeOf value} or types.default;

  concatedString = seperator: list: (convertor {
		default = (seperator: list: "");
		list = (seperator: list: concatStringsSep seperator list);
		string = (seperator: list: list);
	} list) seperator list;
  
	overrideAll = {
    package,
    args ? {},
    attrs ? {}
	}: (package.override args).overrideAttrs attrs;

	isSamePackage = origPkg: modPkg: if
		((hasAttr "pname" origPkg) && (hasAttr "pname" modPkg))
	then
		(origPkg.pname == modPkg.pname)
	else
		(origPkg.name == modPkg.name);
	
	containsPackage = modPkg: origPkgs: any (origPkg: final.isSamePackage origPkg modPkg) origPkgs;

	appendConfig = origConfig: modConfig: origConfig // (intersectAttrs origConfig modConfig);

  oneOfOrDefault =
    value:
    defaultValue:
    possibleValues:
    if
      contains value possibleValues
    then
      value
    else
      defaultValue;

  systemdScript = pkgs: name: text: "${with pkgs; with lib; getExe writeScriptBin ''
#!${getExe nushell}

${text}
  ''}";
}
