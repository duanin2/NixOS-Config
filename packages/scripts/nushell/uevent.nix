{ lib, nushell, writeScript }: writeScript "uevent.nu" ''
#!${lib.getExe nushell}

export def "parseData" [] {
  lines | parse "{name}={value}" | par-each { |it|
    {
      name: $it.name
      value: $it.value
    }
  }
}

export def "getVar" [
  name: string
] {
  where { |it| $it.name == $name } | into value | get value
}
''
