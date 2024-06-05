{ lib, writeScriptBin, name ? "systemd", text ? "true" }: "${with lib; getExe (writeScriptBin name ''
#!${getExe nushell}

${text}
'')}";
