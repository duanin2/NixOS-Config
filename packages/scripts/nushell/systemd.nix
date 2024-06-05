{ lib, writeScriptBin, nushell, name, text }: "${with lib; getExe (writeScriptBin name ''
#!${getExe nushell}

${text}
'')}"
