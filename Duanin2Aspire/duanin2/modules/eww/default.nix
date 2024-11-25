{ lib, pkgs, ... }: let
  launcherContent = pkgs.writeTextFile {
    name = "getLauncherContents.nu";
    text = ''
      #!${lib.getExe pkgs.nushell}

      register ${lib.getExe pkgs.nushellPlugins.formats}

      use language.nu
      use desktopEntry.nu

      let lang = language parse (try { $env.LC_MESSAGES } catch { try { $env.LANG } catch { C } })

      let dataDirs = ((if ($env.XDG_DATA_HOME != "") { $env.XDG_DATA_HOME + ":" }) + $env.XDG_DATA_DIRS) | split row ":"

      let desktopFiles = $dataDirs | each { |it| glob $"($it)/applications/**/*.desktop" } | where { |it| $it != [ ] } | flatten

      let parsed = $desktopFiles | each { |it| { value: (open $it | desktopEntry parse), id: (desktopEntry getId $it) } } | uniq-by id

      $parsed | par-each { par-each { |it| try { { key: $it.key, value: $it.value, language: (language match $it.language $lang) } } catch { { key: $it.key, value: $it.value } } } | sort-by "language" }
    '';
  };
in {
  
}
